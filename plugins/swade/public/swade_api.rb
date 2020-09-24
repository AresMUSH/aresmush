module AresMUSH
  module Swade
  
    def self.die_rating (rating)
      case rating
      when 0
        return "No die"
      when 1
        return "<i class='fad fa-dice-d4'></i>"
      when 2
        return "<i class='fad fa-dice-d6'></i>"
      when 3
        return "<i class='fad fa-dice-d8'></i>"
      when 4
        return "<i class='fad fa-dice-d10'></i>"
      when 5
        return "<i class='fad fa-dice-d12'></i>" 
      end
    end
	
    def self.get_abilities_for_web_viewing(char, viewer)
	
	    # Format skill table
		skills = returnskillsforweb(char.swade_skills)
		skills = skills.join(" ")
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
				rowopenid = i == 0 ? "<div class='container-fluid skillstable'><div class='row'>" : ""
				rowcloseid = i == skills.count ? "</div></div>" : ""
				linebreak = i % 3 == 0 ? " <div class='w-100'></div> " : ""
				cellopenid='<div class="col-sm-4">'
				cellcloseid='</div>'
				title = "#{ a.name }".capitalize
				rating = die_rating(a.rating)
				"#{rowopenid}#{cellopenid}#{title}: #{rating}#{cellcloseid}#{linebreak}#{rowcloseid}"
			end
	end	
  end
end