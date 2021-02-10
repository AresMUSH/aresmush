module AresMUSH
  module Magic
    class GetSpellDamageRequestHandler
      def handle(request)
        puts "YES"

        spells = Global.read_config("spells")
        spells = spells.map {|k, v| {name: v['name'], damage: v['damage_type']}}
        puts spells
        damage = []
        spells.each do |s|
          if s[:damage]
           damage.concat [s[:damage]]
         end

        end
        damage = damage.uniq
        puts damage
        return damage


      end


    end
  end
end
