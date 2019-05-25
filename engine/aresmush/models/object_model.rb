module ObjectModel
  def self.included(base)
    base.send :extend, ClassMethods   
    base.send :register_data_members
  end

  module ClassMethods
    @@default_values = {}
    
    def register_data_members
      send :include, Ohm::DataTypes
      send :include, Ohm::Callbacks
      send :include, Ohm::Timestamps
    end
    
    def find_one(args)
      find(args).first
    end
    
    def dbref_prefix
      self.class.name
    end
  
    def default_values
      @@default_values[self]
    end
    
    def attribute(name, options = nil)
      if (options)
        cast = options[:type]
        default = options[:default]
      end
      super(name, cast)
      if (default)
        if (!@@default_values[self])
          @@default_values[self] = {}
        end
        @@default_values[self][name] = default
      end
    end
  end

  def initialize(attrs = {})
    if (self.class.default_values)
      self.class.default_values.each do |k, v|
        if (!attrs.has_key?(k) && !attrs.has_key?(:id))
          attrs[k] = v
        end
      end
    end
    super(attrs)
  end
  
  def dbref
    "##{self.class.dbref_prefix}-#{self.id}"
  end
  
  def print_json
    JSON.pretty_generate( Hash[self.attributes.sort] )
    #json = JSON.pretty_generate( Hash[self.attributes.sort] )
    #self.methods.each do |m|
    #  if (m.to_s.end_with?('_id'))
    #    method = m.to_s.gsub('_id', '')
    #    if (self.respond_to?(method))
    #      nested = self.send(method)
    #      next if !nested
    #      json << "\n#{method}: #{JSON.pretty_generate( Hash[nested.attributes.sort] )}"
    #    end
    #  end
    #end
    #json
  end
end