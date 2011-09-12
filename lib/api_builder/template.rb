require 'action_view/base'
require 'action_view/template'

module ActionView
  module Template::Handlers
    class ApiBuilder < Template::Handler
      include Compilable

      def compile(template)
        "
        extend ApiBuilder::Renderer
        #{template.source}
        @out.to_json
        "
      end
    end
  end
end

ActionView::Template.register_template_handler :apibuilder, ActionView::Template::Handlers::ApiBuilder
