module ApiBuilder
  class ArrayRenderer
    def self.render(scope, *args, &block)
      renderer = self.new(scope, *args, &block)
      renderer.out
    end

    attr_reader :out

    def initialize(scope, *args, &block)
      @_out = []
      ScopeRenderer.eval(self, scope, &block)
    end

    def element(*args, &block)
      @_out << ElementRenderer.render(self, *args, &block)
    end

    def array(*args, &block)
      @_out << ArrayRenderer.render(self, *args, &block)
    end
  end

  class ElementRenderer
    def self.render(scope, *args, &block)
      renderer = self.new(scope, *args, &block)
      renderer.out
    end

    attr_reader :out

    def initialize(scope, *args, &block)
      if block_given?
        @_out = {}
        ScopeRenderer.eval(self, scope, &block)
      else
        @_out = args[0]
      end
    end

    def id(value)
      @_out.update :id => value
    end

    def property(hash)
      @_out.update hash
    end

    def array(name, &block)
      @_out.update name => ArrayRenderer.render(self, &block)
    end

    def method_missing(name, *args, &block)
      if block_given?
        @_out.update name => ElementRenderer.render(self, &block)
      else
        @_out.update name => args[0]
      end
    end
  end

  class BaseRenderer
    def self.render(scope, format = "json", &block)
      renderer = self.new(scope, &block)
      
      case format.to_sym
      when :json
        renderer.out.to_json
      when :xml
        renderer.out.to_xml
      when :hash
        renderer.out
      else
        raise "unknown format #{format}"
      end
    end

    attr_reader :out

    def initialize(scope, *args, &block)
      ScopeRenderer.eval(self, scope, &block)
    end

    def element(*args, &block)
      raise "root element already defined" unless @_out.nil?
      @_out = ElementRenderer.render(self, *args, &block)
    end

    def array(&block)
      raise "root element already defined" unless @_out.nil?
      @_out = ArrayRenderer.render(self, &block)
    end
  end
  
  class ScopeRenderer
    def self.eval(scope, variable_scope, &block)
      variable_scope.instance_variables.each do |var|
        scope.instance_variable_set(var, variable_scope.instance_variable_get(var)) unless var == "@_out"
      end
      scope.instance_eval(&block)
    end
  end
end