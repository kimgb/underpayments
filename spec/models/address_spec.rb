require 'rails_helper'

RSpec.describe Address, type: :model do
  before(:all) do
    @address = build(:address)
    @invalid_address = build(:invalid_address)
  end

  it "should validate" do
    expect(@address.valid?).to be true
    expect(@invalid_address.valid?).to be false
  end
end
