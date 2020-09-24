module AresMUSH
  module Swade
    def self.get_abilities_for_web_viewing(char, viewer)
	
	    # Format skill table
		rowopenid = "<div class='container-fluid'><div class='row'>"
		rowcloseid = "</div></div>"	
		skilltable = returnskillsforweb(char.swade_skills)
		skills = "#{rowopenid}#{skilltable}#{rowcloseid}"
		#skills = Website.format_markdown_for_html(skills)
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
			linebreak = i % 3 == 0 ? " <div class='w-100'></div> " : ""
			cellopenid='<div class="col-sm">'
			cellcloseid='</div>'
			title = "#{ a.name }".capitalize
			rating = a.rating
			"#{cellopenid}#{title}: #{rating}#{cellcloseid}#{linebreak}"
		end
	end	
  end
end