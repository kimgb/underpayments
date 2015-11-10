module ApplicationHelper
  def page_title
    content_for(:title) || "Underpaid"
  end
end
