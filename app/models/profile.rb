class Profile < ActiveRecord::Base
  include Markdownable
  
  belongs_to :user

  def full_name
    [given_name, family_name].join(" ")
  end

  def owner
    user
  end
end
