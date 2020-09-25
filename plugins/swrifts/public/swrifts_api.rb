module AresMUSH
  module Swrifts
  
    # Return the code to display the font awesome die type based on rating. This should probably be moved to somewhere else.
    def self.die_rating(name,rating)
      case rating.to_i
      when 0
        return "-"
      when 1
        return "<i class='fad fa-dice-d4' title='#{name} d4'></i>"
      when 2
        return "<i class='fad fa-dice-d6' title='#{name} d6'></i>"
      when 3
        return "<i class='fad fa-dice-d8' title='#{name} d8'></i>"
      when 4
        return "<i class='fad fa-dice-d10' title='#{name} d10'></i>"
      when 5
        return "<i class='fad fa-dice-d12' title='#{name} d12'></i>"
      else
 	    return "<i class='fad fa-dice-d12' title='#{name} d12+xxxxx'></i> + (code to add steps)" 
      end
    end
	
    def self.get_abilities_for_web_viewing(char, viewer)
	
	    # Format skill table
		skills = returnskillsforweb(char.swrifts_skills)
		skills = skills.join(" ") #removes the comma's that seperates the entries
		
		#Format Stat Table
		#stats = returnstatsforweb(char.swrifts_stats)
		#stats = stats.join(" ") #removes the comma's that seperates the entries
		
         return {
          skills: skills
        } 
	end
	
	def self.returnskillsforweb(skills)
		skills.to_a.sort_by { |a| a.name }
		.each_with_index
			.map do |a, i| 
				correcttitle = "#{a.name}".titleize
				downsizetitle = "#{a.name}".downcase
				rating = die_rating(correcttitle,a.rating)
				#sets 'iconicf' to the Iconic Framework 'name' of our game\config\swrifts_skills.yml file
				swriftskills = Global.read_config('swrifts', 'skills')
				client.emit (swriftskills.to_yaml)
				#select the skill from the list.
				#swskills = swriftskills.select { |ss| ss['name'].downcase == downsizetitle }.first
				#ssdesc = swskills['description']
				ssdesc = 'hellow world'
				rowopenid = i == 0 ? "<div class='skilltable'><div class='container-fluid skillstable'><div class='row no-gutters'>" : ""
				rowcloseid = i == skills.count ? "</div></div></div>" : ""
				#linebreak = i % 3 == 0 ? " <div class='w-100'></div> " : ""
				linebreak = i % 3 == 0 ? "" : ""
				cssclass = "#{a.name}".strip
				cellopenid='<div class="col-sm-4">'
				colautoopenid="<div class='col-sm-9 heading #{cssclass}'>"
				colsmallopenid="<div class='col-sm-3 rating #{cssclass}'>"
				cellcloseid='</div>'
				title = "<span title='#{correcttitle}: #{ssdesc}'>#{correcttitle}</span>"
				"#{rowopenid}#{cellopenid}#{colautoopenid}#{title}: #{cellcloseid}#{colsmallopenid}#{rating}#{cellcloseid}#{cellcloseid}#{linebreak}#{rowcloseid}"
			end
	end	
  end
end