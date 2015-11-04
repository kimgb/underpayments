class Admin < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable
end
