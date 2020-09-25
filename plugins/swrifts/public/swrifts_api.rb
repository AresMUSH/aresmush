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
	    statstep = "#{rating}"-5
		#statstep=0
 	    return "<i class='fad fa-dice-d12' title='#{name} d12+#{statstep}'></i> + #{statstep} #{rating}"
      end
    end
	
    def self.get_abilities_for_web_viewing(char, viewer)
	    # Format skill table
		skills = returnskillsforweb(char.swrifts_skills)
		skills = skills.join(" ") #removes the comma's that seperates the entries		
		
		stats = returnstatsforweb(char.swrifts_stats)
		stats = stats.join(" ") #removes the comma's that seperates the entries
				
        return {
          skills: skills,
		  stats: stats
        } 
	end
	
	def self.returnskillsforweb(skills)
		skills.to_a.sort_by { |a| a.name }
		.each_with_index
			.map do |a, i| 
				correcttitle = "#{a.name}".titleize
				downsizetitle = "#{a.name}".downcase
				rating = die_rating(correcttitle,a.rating)
				#sets swriftskills to the skills table located in game\config\swrifts_skills.yml file
				swriftskills = Global.read_config('swrifts', 'skills')

				#get the entry in global file that matches the skill name on the character
				swskills = swriftskills.select { |ss| ss['name'].downcase == downsizetitle }.first

				#determine what type of object is being returned. DEBUGGING
				#swsclass2 = swskills.class
				#swdesc2 = ''

				if (swskills)   #if something is returned from the global skills table, set the Desc and Linked Stat.
					swdesc = swskills['description']
					swlinkedstat = swskills['linked_stat']
				else #otherwise set desc and Linked Stat to nothing
					swdesc = ''
					swlinkedstat = ''
				end

				#Set up the skills table
				rowopenid = i == 0 ? "<div class='skilltable'><div class='container-fluid skillstable'><div class='row no-gutters stdlh'><div class='titlerow' colspan='6'>Skills</div>" : ""
				rowcloseid = i == skills.count ? "</div></div></div>" : ""
				openrow = i % 3 == 0 ? " <div class='row skilldata'>" : ""
				#linebreak = i % 3 == 0 ? "" : ""
				cssclass = "#{a.name}".strip
				cellopenid='<div class="col-sm-4">'
				colautoopenid="<div class='col-sm-9 heading #{cssclass}'>"
				colsmallopenid="<div class='col-sm-3 rating #{cssclass}'>"
				cellcloseid='</div>'
				if ( (i > 0 ) && ( (i+1) % 3 == 0) )
					closerow = '</div>'
				else
				    closerow =''
				end
				title = "<span class='skillname' title='#{correcttitle}: #{swdesc}'>#{correcttitle}</span>:<br /><span class='linkedstat'>#{swlinkedstat}</span>"
				"#{rowopenid}#{openrow}#{cellopenid}#{colautoopenid}#{title}#{cellcloseid}#{colsmallopenid}#{rating}#{cellcloseid}#{cellcloseid}#{closerow}#{rowcloseid}"

				# Used for debugging - need to delete when complete
				#"#{downsizetitle} - #{swsclass} - #{swsclass2} - #{swskills} - #{swdesc} - #{swdesc2}<hr />"
			end
	end


	#Get the Stats for the website
	
	def self.returnstatsforweb(stats)
		stats.to_a.sort_by { |a| a.name }
		.each_with_index
			.map do |a, i| 
				correcttitle = "#{a.name}".titleize
				downsizetitle = "#{a.name}".downcase
				rating = die_rating(correcttitle,a.rating)
				#sets swriftskills to the skills table located in game\config\swrifts_stats.yml file
				swriftstats = Global.read_config('swrifts', 'stats')

				#get the entry in global file that matches the skill name on the character
				swstats = swriftstats.select { |ss| ss['name'].downcase == downsizetitle }.first

				if (swstats)   #if something is returned from the global stats table, set the Desc
					swdesc = swstats['description']
				else #otherwise set desc to nothing
					swdesc = ''
				end

				#Set up the stats table
				rowopenid = i == 0 ? "<div class='stattable'><div class='container-fluid statstable'><div class='row no-gutters stdlh'><div class='titlerow' colspan='5'>Stats</div>" : ""
				rowcloseid = i == stats.count ? "</div></div></div>" : ""
				openrow = i % 5 == 0 ? " <div class='row statdata'>" : ""
				cssclass = "#{a.name}".strip
				cellopenid='<div class="col-sm-2">'
				colautoopenid="<div class='col-sm-9 heading #{cssclass}'>"
				colsmallopenid="<div class='col-sm-3 rating #{cssclass}'>"
				cellcloseid='</div>'
				if ( (i > 0 ) && ( (i+1) % 5 == 0) )
					closerow = '</div>'
				else
				    closerow =''
				end
				title = "<span class='statname' title='#{correcttitle}: #{swdesc}'>#{correcttitle}</span>: "
				"#{rowopenid}#{openrow}#{cellopenid}#{title}#{rating}#{cellcloseid}#{closerow}#{rowcloseid}"

				#Used for debugging - need to delete when complete
				#"#{downsizetitle} - #{swstats} - #{swdesc}<hr />"
			end
	end
	
  end
end