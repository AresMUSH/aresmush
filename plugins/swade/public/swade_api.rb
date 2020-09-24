module AresMUSH
  module Swade
    def self.get_abilities_for_web_viewing(char, viewer)
	
	    # Format skill table
		skills = returnskillsforweb(char.swade_skills)
		skills = skill.join(" ")
         return {

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
	
	def self.returnskillsforweb(skills)
		skills.to_a.sort_by { |a| a.name }
		.each_with_index
			.map do |a, i| 
				rowopenid = i == 0 ? "<div class='row'>" : ""
				rowcloseid = i == skills.count ? "</div>" : ""
				linebreak = i % 3 == 0 ? " <div class='w-100'></div> " : ""
				cellopenid='<div class="col-sm-4">'
				cellcloseid='</div>'
				title = "#{ a.name }".capitalize
				rating = a.rating
				"#{rowopenid}#{cellopenid}#{title}: #{rating}#{cellcloseid}#{linebreak}#{rowcloseid}"
			end
	end	
  end
end