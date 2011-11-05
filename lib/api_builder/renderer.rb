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
        elsif @_out.is_a?(Array)
          out = @_out
          @_out = HashWithName.new(name)
          block.call
          out << @_out
          @_out = out
        else # out is a hash
          out = @_out
          @_out = {}
          block.call
          out[name] = @_out
          @_out = out
        end
      elsif name.is_a?(Hash)
        if @_out.nil?
          @_out = StringWithName.new(name.keys[0], name.values[0])
        elsif @_out.is_a?(Array)
          @_out << StringWithName.new(name.keys[0], name.values[0])
        else # out is a hash
          @_out[name.keys[0]] = name.values[0]
        end
      else
        if @_out.nil?
          @_out = StringWithName.new(name, value)
        elsif @_out.is_a?(Array)
          @_out << StringWithName.new(name, value)
        else # out is a hash
          @_out[name] = value
        end
      end
    end
    
    def get_output
      format = request.format.to_sym
      case format
      when :json
        if params[:callback]
          "#{params[:callback]}(#{@_out.to_json})"
        else
          @_out.to_json
        end
      when :xml
        @_out.to_xml
      else
        raise ArgumentError, "unknown format '#{format}'"
      end
    end
  end
end