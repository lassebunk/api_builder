require 'minitest/spec'
require 'minitest/autorun'

require 'json'
require 'logger'
require 'action_view'
require 'api_builder'

class MiniTest::Spec

  Handler = ActionView::Template::Handlers::ApiBuilder

  class LookupContext
    def disable_cache
      yield
    end

    def find_template(*args)
    end
  end

  class Context
    def initialize
      @output_buffer = "original"
      @virtual_path = nil
    end

    def params
      {}
    end

    def request
      OpenStruct.new(format: :json)
    end

    def partial
      ActionView::Template.new(
        "<%= @virtual_path %>",
        "partial",
        Handler,
        :virtual_path => "partial")
    end

    def lookup_context
      @lookup_context ||= LookupContext.new
    end

    def logger
      Logger.new(STDERR)
    end
  end

  def render(fixture, locals = {})
    path = File.expand_path("../fixtures/#{fixture}.apibuilder", __FILE__)
    body = File.read(path)
    tmpl = ActionView::Template.new(body, "#{fixture} template", Handler, { virtual_path: fixture })
    tmpl.locals = locals.keys
    tmpl.render(Context.new, locals)
  end

end
