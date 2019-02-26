module AresMUSH
  module FS3Skills
    class CharSpellsRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        enactor = request.enactor

        if (!char)
          return []
        end

        error = Website.check_login(request, true)
        return error if error


        can_view = FS3Skills.can_view_sheets?(enactor) || (enactor && enactor.id == char.id)
        if (!can_view)
          return { error: t('dispatcher.not_alllowed') }
        end

        spells = []
        spells_learned = char.spells_learned.select { |l| l.learning_complete }
        spells_learned.each do |s|
          roll = Global.read_config("spells", s.name, "roll")
          if roll
            spells << s.name
          end
        end

        return spells
      end
    end
  end
end
