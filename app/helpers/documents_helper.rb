module DocumentsHelper
  def date_from_params(field)
    params[field] && Date.parse(params[field]) || Date.today
  end

  def basename(doc)
    if doc.evidence.present?
      Pathname(doc.evidence.url).basename
    else
      "Statement"
    end
  end
end
