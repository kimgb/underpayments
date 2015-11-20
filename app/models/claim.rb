class Claim < ActiveRecord::Base
  belongs_to :user

  belongs_to :employer
  accepts_nested_attributes_for :employer

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  has_many :documents

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
end
