class Claim < ActiveRecord::Base
  include Markdownable

  belongs_to :employer
  belongs_to :workplace
  has_one :user
  has_many :documents

  validates_presence_of :award, :hourly_pay, :weekly_hours, :employment_type,
    :employment_began_on, :employment_ended_on
  
  scope :submitted?, -> { where(submitted_for_review: true) }
  scope :not_submitted?, -> { where(submitted_for_review: false) }

  # Testing AJAX estimate
  def summary
    "Summary of claim"
  end

  # Override Markdownable defaults
  def self.presentable_attributes
    super.concat(["lost_wages"]).reject{ |attr| ["submitted_for_review", "submitted_on", "hours_self_witnessed"].include? attr }
  end

  # Provide transform methods for Markdownable
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
  
  def hours_evidenced
    documents.sum(:hours)
  end
  
  def hours_evidenced_by_year
    documents.where(time_evidence: true).group_by(&:fy)
      .map { |yr, docs| [yr, docs.map(&:hours).compact.sum] }.to_h
  end
  
  def wages_evidenced
    documents.sum(:wages)
  end

  # Inputs are Date objects
  def hours_worked(period_start = employment_began_on, period_end = employment_ended_on)
    (weekly_hours * weeks_worked(period_start, period_end))
  end
  
  # Inputs are Date objects
  def weeks_worked(period_start, period_end)
    (period_end - period_start) / 7.0
  end
  
  # Note use of Date#fy method that I added via refinement.
  # Australian financial year is from 1 July to 30 June. By (my) convention, Date#fy returns the year that the financial year started in.
  # see `lib/financial_years.rb`: loaded in `config/initializers/extensions.rb`.
  def hours_worked_by_year
    Hash[*(employment_began_on.fy..employment_ended_on.fy).map do |year|
      if employment_began_on.fy == employment_ended_on.fy
        [year, hours_worked]
      elsif year == employment_began_on.fy
        [year, hours_worked(employment_began_on, Date.new(year).end_of_fy)]
      elsif year == employment_ended_on.fy
        [year, hours_worked(Date.new(year).beginning_of_fy, employment_ended_on)]
      else
        [year, hours_worked(Date.new(year).beginning_of_fy, Date.new(year).end_of_fy)]
      end
    end.flatten]
  end
  
  # This is the minimum legal pay 
  def base_pay_for_employment
    hours_worked_by_year.reduce(0.0) do |memo, (year, hours)|
      memo += hours * award_minimum(year)
    end.round(2)
  end
  
  # does not account for pay rises (or falls)
  def actual_pay_for_employment
    hourly_pay * hours_worked
  end

  def stolen_wages
    if payslips_received && coverage_complete?
      stolen_wages_from_evidence
    else
      stolen_wages_from_calculation
    end
  end
  alias_method :lost_wages, :stolen_wages
  
  def stolen_wages_from_calculation
    pay_difference = base_pay_for_employment - actual_pay_for_employment
    
    pay_difference > 0 ? pay_difference.round(2) : 0
  end
  
  def stolen_wages_from_evidence
    base_pay_for_employment - wages_evidenced
  end
  
  def stolen_wages_from_declaration
    
  end

  # 2015 and all horticulture rates are correct, poultry needs numbers for 2010-2014 f.y.'s
  def award_minimum(year = employment_began_on.year)
    {
      2015 => {
        "horticulture" => { "casual" => 21.61, "permanent" => 17.29 },
        "poultry" => { "casual" => 22.34, "permanent" => 17.87 }
      }, 2014 => {
        "horticulture" => { "casual" => 21.09, "permanent" => 16.87 },
        "poultry" => { "casual" => 21.09, "permanent" => 16.87 }
      }, 2013 => {
        "horticulture" => { "casual" => 20.46, "permanent" => 16.37 },
        "poultry" => { "casual" => 20.46, "permanent" => 16.37 }
      }, 2012 => {
        "horticulture" => { "casual" => 19.95, "permanent" => 15.96 },
        "poultry" => { "casual" => 19.95, "permanent" => 15.96 }
      }, 2011 => {
        "horticulture" => { "casual" => 19.39, "permanent" => 15.51 },
        "poultry" => { "casual" => 19.39, "permanent" => 15.51 }
      }, 2010 => {
        "horticulture" => { "casual" => 18.75, "permanent" => 15.00 },
        "poultry" => { "casual" => 18.75, "permanent" => 15.00 }
      }
    }[year][award][employment_type]
  end

  def proper_award
    case award
    when "horticulture" then "Horticulture Award 2010"
    when "poultry" then "Poultry Processing Award 2010"
    end
  end

  def days
    Set.new(employment_began_on..employment_ended_on)
  end

  # calculates document coverage for a type of evidence
  def document_coverage(evidence = :wage_evidence)
    Set.new(documents.where(evidence => true).inject([]) { |memo, doc| memo + doc.days }.sort)
  end

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

  def coverage_complete?(evidence = :wage_evidence)
    coverage_gaps(evidence).empty?
  end
  
  def required_resources
    @required_resources ||= [
      self,
      user,
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
    required_resources.all?(&:present?) && required_resources.all?(&:valid?) && coverage_complete?
  end
  
  def submitted?
    submitted_for_review
  end
  
  def locked?
    submitted?
  end

  def owner
    user
  end
  
  private
  def set_total_hours_by_year
    
  end
end
