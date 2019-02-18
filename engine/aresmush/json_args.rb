module AresMUSH
  # @engineinternal true
  class JsonArgs
    attr_accessor :values
      
    def initialize(json)
      @values = json
    end

    def method_missing(method, *args, &blk)
      # grab base property name, and, if the method is a setter,
      # the `=` at the end - it'll be nil for a reader method
      (/(?<name>.+?)(?<setter>=)?$/ =~ method.to_s) # thanks to Naklion
      property = name.camelize
      if @values.has_key?(property)
        setter ? @values[property] = args.first : @values[property]
      else
        super
      end
    end

    def as_json
      @values
    end
      
    def to_s
      @values.to_s
    end
  end
end