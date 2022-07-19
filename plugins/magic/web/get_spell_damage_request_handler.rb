module AresMUSH
  module Magic
    class GetSpellDamageRequestHandler
      def handle(request)
        Global.logger.debug "Getting Damage Request Handler"

        spells = Global.read_config("spells")
        spells = spells.map {|k, v| {name: v['name'], damage: v['damage_type']}}
        damage = []
        spells.each do |s|
          if s[:damage]
           damage.concat [s[:damage]]
         end

        end
        damage = damage.uniq
        return damage
      end


    end
  end
end
