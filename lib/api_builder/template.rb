require 'action_view/base'
require 'action_view/template'

module ActionView
  module Template::Handlers
    class ApiBuilder < Template::Handler
      include Compilable

      def compile(template)
        "block = lambda { " + template.source + " };" +
        "ApiBuilder::BaseRenderer.render(self, params[:format], &block);"
      end
    end
  end
end

ActionView::Template.register_template_handler :apibuilder, ActionView::Template::Handlers::ApiBuilder
