module DocumentsHelper
  def date_from_params(field)
    params[field] && Date.parse(params[field]) || Date.today
  end

  def basename(doc)
    if doc.file.present?
      Pathname(doc.file.url).basename
    else
      "Affidavit"
    end
  end
end
