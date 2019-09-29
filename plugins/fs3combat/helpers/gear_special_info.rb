module AresMUSH
  module FS3Combat
    class GearSpecialInfo
      attr_accessor :gear_type, :list
      
      def initialize(list, gear_type)
        self.gear_type = gear_type.to_s
        self.list = list
      end
      
      def specials
        if (self.gear_type == "weapon" || self.gear_type == "armor")
          allowed_specials = []
          self.list.each do |fields|
            if (fields[0] == "allowed_specials")
              allowed_specials = fields[1]
            end
          end
          
          specials = {}
          all_specials = self.gear_type == "weapon" ? FS3Combat.weapon_specials : FS3Combat.armor_specials
          all_specials.each do |k, v|
            if (allowed_specials.include?(k))
              specials[k] = special_effects(k, v)
            end
          end
          specials
        else
          {}
        end
      end
      
      def special_effects(name, data)
        effects = []
        data.each do |k, v|
          if (v.class == Hash)
            effect = "#{k.titlecase}: "
            v.each do |x, y|
              effect << " #{x}:#{y}"
            end
          else
            effect = "#{k.titlecase}: #{v}"
          end
          effects << effect
        end
        effects
      end
    end
  end
end