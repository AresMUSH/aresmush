module AresMUSH
  class HashReader
    def initialize(hash)
      @hash = hash
      klass = class << self; self; end
      hash.keys.each do |k|
        if (@hash[k].is_a?(Hash))
          klass.send(:define_method, k) { HashReader.new(@hash[k]) }
        else
          klass.send(:define_method, k) { @hash[k] }
        end
      end
    end
    
    def to_s
      !raw_hash ? "" : raw_hash.to_s
    end
    
    def raw_hash
      @hash
    end
    
    def method_missing(method, *args, &block)
     return nil
    end
  end
end