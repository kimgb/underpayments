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

  def lost_wages
    # baseline
    min_legal_pay = award_minimum * weekly_hours * weeks_worked
    actual_pay = hourly_pay * weekly_hours * weeks_worked
    lost_wages = (min_legal_pay - actual_pay).round(2)

    # return 0 or lost_wages, whichever is higher
    lost_wages > 0 ? lost_wages : 0
  end

  def weeks_worked
    (employment_ended_on - employment_began_on) / 7.0
  end

  def award_minimum
    {
      "horticulture" => { "casual" => 21.61, "permanent" => 17.29 },
      "poultry" => { "casual" => 21.61, "permanent" => 17.29 }
    }[award][employment_type]
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
