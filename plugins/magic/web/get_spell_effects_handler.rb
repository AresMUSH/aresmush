module AresMUSH
  module Magic
    class GetSpellEffectsRequestHandler

      def handle(request)
        Global.logger.debug "Getting Spell Request Handler"
        spells = Global.read_config("spells")
        spells = spells.map {|k, v| {id: v['name'], effect: v['effect']}}
        effects = []
        spells.each do |s|
           effects.concat [s[:effect]]
        end
        effects = effects.uniq
        return effects

        # damage = []
        # spells.each do |s|
        #    damage.concat [s[:damage_type]]
        # end
        #
        # damage = damage.uniq


          # {
          #   effects: effects,
          #   damage: damage
          # }


        # effects = []
        # all_spells = Global.read_config("spells")
        # spells = Magic.build_spell_list(all_spells)
        # spells.each do |s|
        #   effects.concat [Global.read_config("spells", s[:name], "effect")]
        # end
        # effects = effects.uniq


      end


    end
  end
end
