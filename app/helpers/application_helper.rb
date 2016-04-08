module ApplicationHelper
  def page_title
    content_for(:title) || "Underpaid"
  end
  
  def mdash_or_value(val)
    val.blank? ? "&mdash;".html_safe : val
  end
  
  def link_if_unlocked(resource, link_text, path, *args)
    link_to(link_text, path, *args) if current_user.owns?(resource) && !current_user.locked?
  end

  # Requires #presentable_attributes to be defined on the receiving model
  def markdown_model(model)
    klass = model.class
    class_str = klass.to_s.downcase

    html_escape(
      klass.presentable_attributes.map do |attr|
        l10n_key = "views.#{class_str.pluralize}.#{class_str}.#{attr}"
        value = value_with_transform(model.send(attr), klass.attr_transform[attr])

        "**#{I18n.t(l10n_key)}:** #{value}" unless value.blank?
      end.compact.join("  \n")
    )
  end
  
  private
  def locale_list_for_select_options(locale_string)
    I18n.t(locale_string).stringify_keys.to_a.map(&:reverse)
  end
  
  def value_with_transform(value, transform)
    if !transform.present?
      value
    elsif transform[:method].is_a?(Method)
      transform[:method].call(value, *transform[:args])
    elsif transform[:method].is_a?(UnboundMethod)
      transform[:method].bind(value).call(*transform[:args])
    elsif value.respond_to?(transform[:method])
      value.send(transform[:method], *transform[:args])
    end
  end
end
