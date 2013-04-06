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
  end
end