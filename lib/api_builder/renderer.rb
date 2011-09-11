module ApiBuilder
  class ArrayRenderer
    def self.render(*args, &block)
      renderer = self.new(*args, &block)
      renderer.out
    end

    attr_reader :out

    def initialize(*args, &block)
      @out = []
      instance_eval(&block)
    end

    def element(*args, &block)
      @out << ElementRenderer.render(*args, &block)
    end

    def array(*args, &block)
      @out << ArrayRenderer.render(*args, &block)
    end
  end

  class ElementRenderer
    def self.render(*args, &block)
      renderer = self.new(*args, &block)
      renderer.out
    end

    attr_reader :out

    def initialize(*args, &block)
      if block_given?
        @out = {}
        instance_eval(&block)
      else
        @out = args[0]
      end
    end

    def id(value)
      @out.update :id => value
    end

    def property(hash)
      @out.update hash
    end

    def array(name, &block)
      @out.update name => ArrayRenderer.render(&block)
    end

    def method_missing(name, *args, &block)
      if block_given?
        @out.update name => ElementRenderer.render(&block)
      else
        @out.update name => args[0]
      end
    end
  end

  class BaseRenderer
    def self.render(format = "json", &block)
      renderer = self.new(&block)
      
      case format.to_sym
      when :json
        renderer.out.to_json
      when :xml
        renderer.out.to_xml
      else
        raise "unknown format #{format}"
      end
    end

    attr_reader :out

    def initialize(*args, &block)
      instance_eval(&block)
    end

    def element(*args, &block)
      raise "root element already defined" unless @out.nil?
      @out = ElementRenderer.render(*args, &block)
    end

    def array(&block)
      raise "root element already defined" unless @out.nil?
      @out = ArrayRenderer.render(&block)
    end
  end
end