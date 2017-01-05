class Lookup < ActiveRecord::Base
  validates :system_value, uniqueness: { scope: :type }
end
