class Claim < ActiveRecord::Base
  include Markdownable

  belongs_to :employer
  has_one :user
  has_one :address, as: :addressable
  has_many :documents

  # belongs_to :user

  # belongs_to :employer
  # accepts_nested_attributes_for :employer

  # has_one :address, as: :addressable
  # accepts_nested_attributes_for :address

  # has_many :documents

  validates_presence_of :award, :hourly_pay, :weekly_hours, :employment_type

  # Testing AJAX estimate
  def summary
    "Summary of claim"
  end

  # Override Markdownable defaults
  def presentable_attributes
    super.merge({ "lost_wages" => lost_wages })
  end

  # Provide transform methods for Markdownable
  def attr_transform
    {
      "weekly_hours" => ActionController::Base.helpers.method(:number_with_delimiter),
      "hourly_pay" => ActionController::Base.helpers.method(:number_to_currency),
      "lost_wages" => ActionController::Base.helpers.method(:number_to_currency)
    }
  end

  def hours_worked
    (weekly_hours * weeks_worked).round
  end
  
  def hours_worked_by_year
    if employment_began_on.fy == employment_ended_on.fy
      { employment_began_on.fy => weeks_worked }
    else
      Hash[*(employment_began_on.fy..employment_ended_on.fy).map do |year|
        if year == employment_began_on.fy
          [year, weeks_worked(employment_began_on, Date.new(year).end_of_fy) * weekly_hours]
        elsif year == employment_ended_on.fy
          [year, weeks_worked(Date.new(year).beginning_of_fy, employment_ended_on) * weekly_hours]
        else
          [year, weeks_worked(Date.new(year).beginning_of_fy, Date.new(year).end_of_fy) * weekly_hours]
        end
      end.flatten]
    end
  end
  
  # def weeks_worked_by_year
  #   if employment_began_on.year == employment_ended_on.year
  #     { employment_began_on.year => weeks_worked }
  #   else
  #     Hash[*(employment_began_on.year..employment_ended_on.year).map do |year|
  #       if year == employment_began_on.year
  #         [year, weeks_worked(employment_began_on, Date.new(year).end_of_year)]
  #       elsif year == employment_ended_on.year
  #         [year, weeks_worked(Date.new(year).beginning_of_year, employment_ended_on)]
  #       else
  #         [year, weeks_worked(Date.new(year).beginning_of_year, Date.new(year).end_of_year)]
  #       end
  #     end.flatten]
  #   end
  # end
  
  def base_pay_for_employment
    hours_worked_by_year.reduce(0.0) do |memo, (year, hours)|
      memo += hours * award_minimum(year)
    end.round(2)
  end
  
  # does not account for pay rises (or falls)
  def actual_pay_for_employment
    hourly_pay * weekly_hours * weeks_worked
  end

  def lost_wages
    pay_difference = base_pay_for_employment - actual_pay_for_employment
    
    pay_difference > 0 ? pay_difference.round(2) : 0
  end

  def weeks_worked(period_start = employment_began_on, period_end = employment_ended_on)
    (period_end - period_start) / 7.0
  end

  def award_minimum(year = employment_began_on.year)
    {
      2015 => {
        "horticulture" => { "casual" => 21.61, "permanent" => 17.29 },
        "poultry" => { "casual" => 21.61, "permanent" => 17.29 }
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

  # Confirms all information needed to generate Letter of Demand and fill out FCC forms is present
  # => Claim is validated
  # => Claim is associated to a validated user that is associated to a validated address
  # => Claim is associated to a validated address
  # => Claim is associated to a validated employer
  def ready_to_submit?
    required_resources = [self, user, if user then user.address end, address, employer].freeze
    required_resources.all?(&:present?) && required_resources.all?(&:valid?) && coverage_complete?

    # old version, &&= makes false sticky
    # ready = true
    # required_resources.each { |res| ready &&= res.present? && res.valid? }

    # ready
  end

  def owner
    user
  end
end
