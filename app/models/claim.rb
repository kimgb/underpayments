class Claim < ActiveRecord::Base
  include Markdownable
  
  has_one :user
  has_many :documents

  has_many :claim_companies, -> { where(is_active: true) }, inverse_of: :claim
  has_many :companies, through: :claim_companies

  validates_presence_of :award, :hourly_pay, :weekly_hours, :employment_type,
    :employment_began_on, :employment_ended_on
  validate :employment_begins_before_employment_ends
  
  scope :submitted?, -> { where(submitted_for_review: true) }
  scope :not_submitted?, -> { where(submitted_for_review: false) }
  
  ### MARKDOWNABLE CONFIG - class methods
  def self.presentable_attributes
    super.concat(["lost_wages"]).reject do |attr| 
      [
        "submitted_for_review", 
        "submitted_on", 
        "hours_self_witnessed", 
        "payslips_received"
      ].include? attr
    end
  end

  def self.attr_transform
    {
      "weekly_hours" => { method: ActionController::Base.helpers.method(:number_with_delimiter), args: [] },
      "hourly_pay" => { method: ActionController::Base.helpers.method(:number_to_currency), args: [] },
      "lost_wages" => { method: ActionController::Base.helpers.method(:number_to_currency), args: [] },
      "employment_ended_on" => { method: Date.instance_method(:to_formatted_s), args: [:rfc822] },
      "employment_began_on" => { method: Date.instance_method(:to_formatted_s), args: [:rfc822] }
      # "employment_ended_on" => { method: :to_formatted_s, args: [:rfc822] }
      # "employment_began_on" => { method: :to_formatted_s, args: [:rfc822] },
    }
  end
  
  ### INSTANCE METHODS
  def duration_of_employment_in_days
    "#{(employment_ended_on - employment_began_on).to_i} days"
  end
  
  #############################################################################
  #-- AFFIDAVIT GENERATION METHODS
  #############################################################################
  def affidavit_generator
    {
      wage_evidence: true,
      time_evidence: true,
      wages: estimated_wages_paid,
      hours: estimated_hours_worked,
      coverage_start_date: employment_began_on,
      coverage_end_date: employment_ended_on,
      statement: affidavit_statement
    }
  end
  
  # Takes the array from affidavit_statements and turns it into a string, containing a preamble and numbered list.
  def affidavit_statement
    affidavit_statements.join("\n\n")
  end
  
  # An array of statements, in particular order, based on supplied information.
  def affidavit_statements(t_scope = "controllers.claim.affidavit")
    statements = [
      I18n.t('preamble', scope: t_scope, name: owner.full_name, address: owner.address.to_s),
      I18n.t('one', scope: t_scope, country: owner.profile.country_of_origin),
      I18n.t('two', scope: t_scope, visa_statement: owner.profile.visa_string_for_statement),
      I18n.t('three', scope: t_scope, workplace: workplace.name, address: workplace.address.to_s, date: employment_began_on.to_s(:rfc822)),
      I18n.t('four', scope: t_scope, employer: (employer || workplace).name),
      I18n.t('five', scope: t_scope, employer: (employer || workplace).name, hours: ActionController::Base.helpers.number_with_delimiter(hours_worked.round(2))),
      I18n.t('six', scope: t_scope, hours: ActionController::Base.helpers.number_with_delimiter(hours_worked.round(2)), dollars: ActionController::Base.helpers.number_to_currency(actual_pay.round(2))),
      I18n.t('seven', scope: t_scope, dollars: ActionController::Base.helpers.number_to_currency(stolen_wages.round(2)), award: proper_award),
    ]
    
    if pieceworker
      statements = statements + [
        I18n.t('pieceworker.one', scope: t_scope),
        I18n.t('pieceworker.two', scope: t_scope, duration: ActionController::Base.helpers.number_with_delimiter(duration_of_employment_in_days)),
        I18n.t('pieceworker.three', scope: t_scope),
      ]
    end
    
    statements
  end
  
  def display_affidavit?
    !payslips_received
  end
  
  def enable_affidavit?
    [owner.profile, workplace, employer].all? do |e| 
      e.present? && e.address.present? && e.valid? && e.address.valid?
    end
  end
  
  def has_statement?
    documents.any? { |doc| doc.statement.present? }
  end
  
  # Claim#presentable_companies - more appropriate as a helper?
  def presentable_companies
    claim_companies.where("true in (is_workplace, is_employer)")
    # companies.all { |co| co.presentable_against?(self) }
  end
  
  # Claim#stolen_wages()
  # It all boils down to this. Based on evidence coverage, uses several
  # different methods of calculation to report the claimant's stolen wages.
  def stolen_wages
    sw = award_pay - actual_pay
    
    sw > 0 ? sw.round(2) : 0
  end
  alias_method :lost_wages, :stolen_wages
  
  # CLaim#actual_pay
  # Based on evidence coverage, calls the best method to determine pay received.
  def actual_pay
    if coverage_complete?(:wage_evidence)
      wages_from_evidence
    elsif coverage_complete?(:time_evidence)
      estimated_wages_from_time_evidence
    else
      estimated_wages_paid
    end
  end
  
  # Claim#award_pay
  # Based on evidence coverage, calls the best method to determine hours worked.
  def award_pay
    coverage_complete?(:time_evidence) ? min_award_pay_from_evidence : estimated_min_award_pay
  end
  
  # Claim#hours_worked
  # 'Top' level method that answers based on evidence completeness.
  def hours_worked
    coverage_complete?(:time_evidence) ? hours_from_evidence : estimated_hours_worked
  end
  
  # Claim#underpaid?
  # Simple true/false report
  def underpaid?
    stolen_wages > 0
  end

  # Claim#award_minimum()
  # Deeply nested hash with award level 1 rates by financial year, award, employment type.
  # 2015 and all horticulture/awardless rates are correct.
  # Poultry needs numbers for 2010-2014 f.y.'s
  def award_minimum(year = employment_began_on.year)
    Hash.new({ # default to current year's rates. (2015-2016)
      "horticulture" => { "casual" => 21.61, "permanent" => 17.29, "unknown" => 21.61 },
      "poultry" => { "casual" => 22.34, "permanent" => 17.87, "unknown" => 22.34 },
      "no_award" => { "casual" => 21.61, "permanent" => 17.29, "unknown" => 21.61 }
    }).merge({
      2015 => {
        "horticulture" => { "casual" => 21.61, "permanent" => 17.29, "unknown" => 21.61 },
        "poultry" => { "casual" => 22.34, "permanent" => 17.87, "unknown" => 22.34 },
        "no_award" => { "casual" => 21.61, "permanent" => 17.29, "unknown" => 21.61 }
      }, 2014 => {
        "horticulture" => { "casual" => 21.09, "permanent" => 16.87, "unknown" => 21.09 },
        "poultry" => { "casual" => 21.09, "permanent" => 16.87, "unknown" => 21.09 },
        "no_award" => { "casual" => 21.09, "permanent" => 16.87, "unknown" => 21.09 }
      }, 2013 => {
        "horticulture" => { "casual" => 20.46, "permanent" => 16.37, "unknown" => 20.46 },
        "poultry" => { "casual" => 20.46, "permanent" => 16.37, "unknown" => 20.46 },
        "no_award" => { "casual" => 20.46, "permanent" => 16.37, "unknown" => 20.46 }
      }, 2012 => {
        "horticulture" => { "casual" => 19.95, "permanent" => 15.96, "unknown" => 19.95 },
        "poultry" => { "casual" => 19.95, "permanent" => 15.96, "unknown" => 19.95 },
        "no_award" => { "casual" => 19.95, "permanent" => 15.96, "unknown" => 19.95 }
      }, 2011 => {
        "horticulture" => { "casual" => 19.39, "permanent" => 15.51, "unknown" => 19.39 },
        "poultry" => { "casual" => 19.39, "permanent" => 15.51, "unknown" => 19.39 },
        "no_award" => { "casual" => 19.39, "permanent" => 15.51, "unknown" => 19.39 }
      }, 2010 => {
        "horticulture" => { "casual" => 18.75, "permanent" => 15.00, "unknown" => 18.75 },
        "poultry" => { "casual" => 18.75, "permanent" => 15.00, "unknown" => 18.75 },
        "no_award" => { "casual" => 18.75, "permanent" => 15.00, "unknown" => 18.75 }
      }
    }).dig(year, award, employment_type)
  end

  # Better as a helper?
  def proper_award
    case award
    when "horticulture" then "Horticulture Award 2010"
    when "poultry" then "Poultry Processing Award 2010"
    end
  end

  #############################################################################
  #-- COVERAGE METHODS
  #-- These methods work together to report back coverage completion of wages
  #-- and time evidence. They can also report gaps in coverage.
  #############################################################################
  
  # Claim#days()
  # Returns a set of days for the claim's employment period.
  def days
    Set.new(employment_began_on..employment_ended_on)
  end

  # Claim#document_coverage()
  # Returns a set of days that are covered by documents of a certain evidence 
  # type, default :wage_evidence.
  def document_coverage(evidence = :wage_evidence)
    Set.new(documents.where(evidence => true).inject([]) { |memo, doc| memo + doc.days }.sort)
  end

  # Claim#coverage_gaps()
  # Gets the set difference of Claim#days and Claim#document_coverage. Anything
  # left in the resulting set is a gap in coverage, for the requested evidence
  # type. Consecutive days are then sliced together before returning.
  def coverage_gaps(evidence = :wage_evidence)
    # get the set difference - note set difference returns an array
    missing_days = days - document_coverage(evidence)

    # if there are no missing days, short circuit out of here
    return missing_days if missing_days.empty?

    # get an array of arrays of blocks of consecutive days
    actual = missing_days.first.prev_day
    gaps = missing_days.slice_before do |dt|
      expected, actual = actual.next_day, dt
      expected != actual
    end.to_a
  end

  # Claim#coverage_complete?()
  # If there are no gaps for the evidence type, we have complete coverage.
  def coverage_complete?(evidence = :wage_evidence)
    coverage_gaps(evidence).empty?
  end
  
  #############################################################################
  #-- CUSTOM COMPANY ASSOCIATION METHODS
  #-- The two methods below are provided on the basis that a claim should never
  #-- have more than one active workplace or employer, even though it can have
  #-- multiple companies.
  #--
  #-- Ownership methods necessary for all models.
  #############################################################################
  def workplace
    @workplace ||= claim_companies.workplace.first && 
      claim_companies.workplace.first.company
  end
  
  def employer
    @employer ||= claim_companies.employer.first && 
      claim_companies.employer.first.company
  end  

  def owner
    user
  end
  
  def owners
    [owner].compact
  end
  
  #############################################################################
  #-- MISC
  #############################################################################
  def required_resources
    @required_resources ||= [
      self,
      user,
      if user then user.profile end,
      if user then user.address end,
      workplace,
      if workplace then workplace.address end,
      employer,
      if employer then employer.address end
    ].freeze
  end

  # Confirms all information needed to generate Letter of Demand and fill out FCC forms is present
  # => Claim is validated
  # => Claim is associated to a validated user with a validated address
  # => Claim is associated to a validated workplace with a validated address
  # => Claim is associated to a validated employer with a validated address
  def ready_to_submit?
    required_resources.all?(&:present?) && required_resources.all?(&:valid?) && 
      coverage_complete? && coverage_complete?(:time_evidence)
  end
  
  def done?
    valid? && coverage_complete? && coverage_complete?(:time_evidence)
  end
  
  def submitted?
    submitted_for_review
  end
  alias_method :locked?, :submitted?
  
  private
  ### CUSTOM VALIDATIONS
  def employment_begins_before_employment_ends
    if employment_began_on > employment_ended_on
      errors.add(:employment_began_on, "must be before employment end date")
    end
  end
  
  def set_total_hours_by_year
  end
  
  
  #############################################################################
  #-- EVIDENCE METHODS
  #-- These methods aim to provide a more reliable figure based on subsequent
  #-- user upload of evidence and statements. Some still depend partly on
  #-- estimation methods above.
  #############################################################################
  
  # Claim#hours_from_evidence()
  # Simply sums the values of associated documents' hours attribute.
  def hours_from_evidence
    documents.sum(:hours)
  end
  
  # Claim#hours_from_evidence_by_year()
  # For when calculating award minimum, returns a hash with years as keys and
  # hours worked in the year as values.
  # PITFALL: the Document#fy method will return the financial year in which it
  # mostly falls.
  def hours_from_evidence_by_year
    documents.where(time_evidence: true).group_by(&:fy)
      .map { |yr, docs| [yr, docs.map(&:hours).compact.sum] }.to_h
  end
  
  # Claim#wages_from_evidence()
  # Simply sums the values of associated documents' wages attribute.
  def wages_from_evidence
    documents.sum(:wages)
  end
  
  # Claim#min_award_pay_from_evidence()
  # Uses Claim#hours_from_evidence_by_year and multiplies each year's hours by
  # the relevant historical award minimum rate.
  def min_award_pay_from_evidence
    hours_from_evidence_by_year.reduce(0) { |sum, (yr, hrs)| sum += hrs * award_minimum(yr) }
  end
  
  # Claim#estimated_wages_from_time_evidence()
  # Part estimate, part evidence. Multiplies user supplied hourly pay by the 
  # sum of hours in evidence.
  # TODO figure a way to allow changes in pay rate to be reported.
  def estimated_wages_from_time_evidence
    hourly_pay * hours_from_evidence
  end
  
  #############################################################################
  #-- ESTIMATING METHODS
  #-- These methods calculate estimates from the initial user input.
  #############################################################################  
  
  # Claim#weeks_worked(Date.today - 3.months, Date.today) => 13.0
  # Returns number of weeks between two Date objects. Inputs are Date objects
  # because days are the unit for arithmetic ops.
  def weeks_worked(period_start = employment_began_on, period_end = employment_ended_on)
    (period_end - period_start) / 7.0
  end
  
  # Claim#estimated_hours_worked()
  # Multiplies the initial user input of avg weekly hours by the number of weeks
  # between two dates. As above, inputs are Date objects.
  def estimated_hours_worked(period_start = employment_began_on, period_end = employment_ended_on)
    (weekly_hours * weeks_worked(period_start, period_end))
  end
  
  # Claim#estimated_hours_worked_by_year()
  # Returns a hash with years as keys and a pro rated estimate of hours as vals.
  # Note use of Date#fy method that I added via refinement  Australian financial
  # year is from 1 July to 30 June. By (my) convention, Date#fy returns the year
  # that the financial year started in.
  # see `lib/financial_years.rb`: loaded in `config/initializers/extensions.rb`.
  # FIXME: seems to be dropping a day for each fy
  def estimated_hours_worked_by_year
    Hash[*(employment_began_on.fy..employment_ended_on.fy).map do |year|
      if employment_began_on.fy == employment_ended_on.fy
        [year, estimated_hours_worked]
      elsif year == employment_began_on.fy
        [year, estimated_hours_worked(employment_began_on, employment_began_on.end_of_fy)]
      elsif year == employment_ended_on.fy
        [year, estimated_hours_worked(employment_ended_on.beginning_of_fy - 1, employment_ended_on)]
      else
        [year, estimated_hours_worked(Date.new(year).end_of_fy, Date.new(year+1).end_of_fy)]
      end
    end.flatten]
  end
  
  # Claim#estimated_min_award_pay()
  # Returns the absolute legal minimum pay, based on estimated hours per year, 
  # user supplied award and employment type. 
  def estimated_min_award_pay
    estimated_hours_worked_by_year.reduce(0.0) do |memo, (year, hours)|
      memo += hours * award_minimum(year)
    end.round(2)
  end
  
  # Claim#estimated_wages_paid()
  # Returns an estimate of what was actually paid the claimant, based on their
  # input of pay per hour, avg. hours per week and length of employment.
  # TODO figure a way to allow changes in pay rate to be reported.
  def estimated_wages_paid
    hourly_pay * estimated_hours_worked
  end
end
