module AresMUSH
  module Swade
    class AbilitiesRequestHandler
      def handle(request)
        #skills = format_three_per_line @char.swade_skills
		skills = "Hello World" 
        {  
         
          skills: skills
		  # Copied from the FS3 stuff.
		  
		  # attrs: attrs,
          # action_skills: action_skills,
          # backgrounds: backgrounds,
          # languages: languages,
          # advantages: advantages,
          # use_advantages: FS3Skills.use_advantages?
        } 
      end
    end
  end
end


