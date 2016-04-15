# Letter of demand
# not persisted to database (does not inherit from ActiveRecord).
class Letter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :addressee, :signature, :contact_inbox

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
