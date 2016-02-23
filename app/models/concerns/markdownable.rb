# View concern intruding on the model - damn
module Markdownable
  extend ActiveSupport::Concern

  # More work to be done here. "Transforms" need to be performed on some values - view helpers 
  # such as number_with_delimiter or number_with_currency. This stuff, of necessity, has to be 
  # defined at the class level.

  # only one variation for now. uses the other two methods to build a markdown string.
  # def markdown
  #   presentable_attributes.inject("") { |memo, (k, v)| memo + key_value_markdown(k, v) }.strip
  # end

  # simple rules, but class can override. Devise, for instance, creates a bunch more attributes.
  module ClassMethods
    def presentable_attributes
      attribute_names.reject do |attr| 
        ["id", "created_at", "updated_at"].include?(attr) || attr.end_with?("_id", "_type")
      end
    end

    def attr_transform
      {}
    end
  end

  # builds markdown attributes for key: value style presentation
  # def key_value_markdown(attr_key, attr_val)
  #   klass = self.class.to_s.downcase
  #   l10n_key = "views.#{klass.pluralize}.#{klass}.#{attr_key}"

  #   # two spaces before the line break is parsed as <br>
  #   attr_val.blank? ? "" : "**#{I18n.t(l10n_key)}:** #{attr_val}  \n"
  # end
end
