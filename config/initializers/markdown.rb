module Haml::Filters
  # remove the existing Markdown filter
  remove_filter("Markdown")

  module Markdown
    include Haml::Filters::Base

    def render(text)
      Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, no_intra_emphasis: true).render(text)
    end
  end
end
