module DocumentsHelper
  def date_from_params(field)
    params[field] && Date.parse(params[field]) || Date.today
  end
  
  def date_to_time_tag(date)
    "<time datetime=#{date}>#{date.to_s(:long)}</time>"
  end

  def basename(doc)
    if doc.evidence.present?
      Pathname(doc.evidence.path).basename
    else
      "Statement"
    end
  end
end
