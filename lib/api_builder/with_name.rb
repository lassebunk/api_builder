module ApiBuilder
  class HashWithName < Hash
    send :attr_accessor, :name
    
    def initialize(name)
      @name = name
    end

    def to_xml(options = {})
      super options.update(:root => name, :skip_types => true, :dasherize => false)
    end
  end

  class ArrayWithName < Array
    send :attr_accessor, :name
    
    def initialize(name)
      @name = name
    end

    def to_xml(options = {})
      super options.update(:root => name, :skip_types => true, :dasherize => false)
    end
  end

  class StringWithName < String
    send :attr_accessor, :name
    
    def initialize(name, value)
      @name = name
      super value.to_s
    end

    def to_xml(options = {})
      if options[:builder]
        xml = options[:builder]
      else
        xml = Builder::XmlMarkup.new
        xml.instruct!
      end
      xml.tag! name, to_s
    end
  end
end