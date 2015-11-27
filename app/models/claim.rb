class Claim < ActiveRecord::Base
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

  validates_presence_of :award, :hourly_pay, :total_hours, :employment_type

  def lost_wages
    # baseline
    min_legal_pay = award_minimum[self.award] * self.total_hours
    actual_pay = self.hourly_pay * self.total_hours
    lost_wages = (min_legal_pay - actual_pay).round(2)

    lost_wages > 0 ? lost_wages : 0
  end

  def award_minimum
    { "horticulture" => 21.61, "poultry" => 21.61 }
  end

  # Confirms all information needed to generate Letter of Demand and fill out FCC forms is present
  # => Claim is validated
  # => Claim is associated to a validated user that is associated to a validated address
  # => Claim is associated to a validated address
  # => Claim is associated to a validated employer
  def ready_to_submit?
    ready = true
    conditional_resources = [self, user, user.address, address, employer].freeze
    # &&= makes false sticky
    conditional_resources.each { |res| ready &&= res.present? && res.valid? }
    # conditional_resources.inject(true) { |ready, res| ready && res.present? && res.valid? }

    ready
  end

  def owner
    self.user
  end
end
