# Letter of demand
# not persisted to database (does not inherit from ActiveRecord).
class Letter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :addressee, :address, :signature, :contact_inbox

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end
end
