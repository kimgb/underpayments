module ApplicationHelper
  def page_title
    content_for(:title) || "Underpaid"
  end

  # Requires #presentable_attributes to be defined on the receiving model
  def markdown_model(model)
    klass = model.class.to_s.downcase

    model.presentable_attributes.map do |k, v|
      l10n_key = "views.#{klass.pluralize}.#{klass}.#{k}"
      value_with_transform = model.attr_transform[k] ? model.attr_transform[k].call(v) : v

      "**#{I18n.t(l10n_key)}:** #{value_with_transform}" unless v.blank?
    end.compact.join("  \n")
  end
end
