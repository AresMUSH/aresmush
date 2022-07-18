module AresMUSH
  module Magic
    class GetSpellEffectsRequestHandler

      def handle(request)
        spells = Global.read_config("spells")
        spells = spells.map {|k, v| {id: v['name'], effect: v['effect']}}
        effects = []
        spells.each do |s|
           effects.concat [s[:effect]]
        end
        effects = effects.uniq.sort
        return effects
      end

    end
  end
end
