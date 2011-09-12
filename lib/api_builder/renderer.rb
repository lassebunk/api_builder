module ApiBuilder
  module Renderer
    def method_missing(name, *args, &block)
      @out = {} if @out.nil?

      if block_given?
        out = @out
        @out = {}
        block.call
        out[name] = @out
        @out = out
      else
        @out[name] = args[0]
      end
    end

    def array(*args, &block)
      if @out.nil?
        @out = []
        block.call
      elsif @out.is_a?(Array)
        out = @out
        @out = []
        block.call
        out << @out
        @out = out
      else # out is a hash
        out = @out
        @out = []
        block.call
        out[args[0]] = @out
        @out = out
      end
    end

    def element(*args, &block)
      if block_given?
        if @out.nil?
          @out = {}
          block.call
        else
          out = @out
          @out = {}
          block.call
          out << @out
          @out = out
        end
      else
        if @out.nil?
          @out = args[0]
        else
          @out << args[0]
        end
      end
    end
  end
end