module DateSelectHelper
  private
  def fill_date(attr_selector, date)
    page.find("#" + attr_selector + "_3i").set date.day
    page.find("#" + attr_selector + "_2i").set Date::MONTHNAMES[date.month]
    page.find("#" + attr_selector + "_1i").set date.year
  end
end
