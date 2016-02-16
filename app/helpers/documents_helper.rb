module DocumentsHelper
  def date_from_params(field)
    params[field] && Date.parse(params[field]) || Date.today
  end

  def basename(doc)
    Pathname(doc.file.url).basename
  end
end
