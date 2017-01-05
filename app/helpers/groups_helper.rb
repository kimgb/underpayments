module GroupsHelper
  def awards_for_select
    awards = Award.all
    
    awards.map(&:name).zip(awards.map(&:id))
  end
end
