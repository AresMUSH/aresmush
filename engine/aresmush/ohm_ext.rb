module Ohm
  # @engineinternal true
  class Model
    def update_attributes(atts)
      atts.each do |att, val| 
        begin
          send(:"#{att}=", val) 
        rescue NoMethodError => ex
          AresMUSH::Global.logger.warn "Model #{self.class} failed to respond to #{att} #{ex}"
        end
      end
    end
  end
end