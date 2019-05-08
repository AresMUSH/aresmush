module AresMUSH
  module FS3Skills
    class CharAbilitiesRequestHandler
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
        
        abilities = []
      
        [ char.fs3_attributes, char.fs3_action_skills, char.fs3_background_skills, char.fs3_languages, char.fs3_advantages ].each do |list|
          list.each do |a|
            abilities << a.name
          end
        end
        
        return abilities
      end
    end
  end
end