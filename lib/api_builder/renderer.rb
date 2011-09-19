module ApiBuilder
  module Renderer
    def id(*args, &block)
      method_missing(:id, *args, &block)
    end
    
    def method_missing(name, *args, &block)
      @_out = {} if @_out.nil?

      if block_given?
        out = @_out
        @_out = {}
        block.call
        out[name] = @_out
        @_out = out
      else
        @_out[name] = args[0]
      end
    end

    def array(name, value = nil, &block)
      if @_out.nil?
        @_out = ArrayWithName.new(name)
        block.call
      elsif @_out.is_a?(Array)
        out = @_out
        @_out = ArrayWithName.new(name)
        block.call
        out << @_out
        @_out = out
      else # out is a hash
        out = @_out
        @_out = []
        block.call
        out[name] = @_out
        @_out = out
      end
    end

    def element(name, value = nil, &block)
      if block_given?
        if @_out.nil?
          @_out = HashWithName.new(name)
          block.call
        else
          out = @_out
          @_out = HashWithName.new(name)
          block.call
          out << @_out
          @_out = out
        end
      else
        if @_out.nil?
          @_out = StringWithName.new(name, value)
        else
          @_out << StringWithName.new(name, value)
        end
      end
    end
    
    def get_output
      case params[:format].to_sym
      when :json
        if params[:callback]
          "#{params[:callback]}(#{@_out.to_json})"
        else
          @_out.to_json
        end
      when :xml
        @_out.to_xml
      else
        raise "unknown format '#{params[:format]}'"
      end
    end
  end
end