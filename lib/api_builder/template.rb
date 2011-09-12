require 'action_view/base'
require 'action_view/template'

module ActionView
  module Template::Handlers
    class ApiBuilder

      def self.call(template)
        "
        extend ApiBuilder::Renderer
        #{template.source}
        get_output
        "
      end
    end
  end
end

ActionView::Template.register_template_handler :apibuilder, ActionView::Template::Handlers::ApiBuilder
