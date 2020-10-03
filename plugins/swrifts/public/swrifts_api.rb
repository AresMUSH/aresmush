module AresMUSH
  module Swrifts
  
	
    # Return the code to display the font awesome die type based on rating. This should probably be moved to somewhere else.
    def self.die_rating(name,rating)
	  rating = "#{rating}".to_i
      case rating
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
	    statstep = rating-5
 	    return "<i class='fad fa-dice-d12' title='#{name} d12+#{statstep}'></i> +<span class='statrating'>#{statstep}</span>"
      end
    end
	
    def self.get_abilities_for_web_viewing(char, viewer)
	    # Format skill table
		skills = returnskillsforweb(char.swrifts_skills)
		skills = skills.join(" ") #removes the comma's that seperates the entries		
		
		stats = returnstatsforweb(char.swrifts_stats)
		stats = stats.join(" ") #removes the comma's that seperates the entries
		
		#bennies = returnbenniesforweb(char.swrifts_bennies)
		

		#conviction = returnconvictionforweb(char.swrifts_conviction)
		#conviction = conviction.join(" ") #removes the comma's that seperates the entries
		
        return {
          skills: skills,
		  stats: stats,
		  #bennies: bennies,
		  #conviction: conviction
        } 
	end
	
	#Get skills for website
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

				if (swskills)   #if something is returned from the global skills table, set the Desc and Linked Stat.
					swdesc = swskills['description']
					swlinkedstat = swskills['linked_stat']
				else #otherwise set desc and Linked Stat to nothing
					swdesc = ''
					swlinkedstat = ''
				end

				#Set up the skills table		
				openrow = i % 3 == 0 ? " <div class='row skills skilldata'>" : ""
				cssclass = "#{a.name}".strip
				cellopenid="<div class='col-sm-4'>"
				colautoopenid="<div class='col-sm-9 heading #{cssclass}'>"
				colsmallopenid="<div class='col-sm-3 rating #{cssclass}'>"
				cellcloseid='</div>'
				if ( (i > 0 ) && ( (i+1) % 3 == 0) )
					closerow = '</div>'
				else
				    closerow =''
				end
				title = "<span class='skillname' title='#{correcttitle}: #{swdesc}'>#{correcttitle}</span>:<br /><span class='linkedstat'>#{swlinkedstat}</span>"
				"#{openrow}#{cellopenid}#{colautoopenid}#{title}#{cellcloseid}#{colsmallopenid}#{rating}#{cellcloseid}#{cellcloseid}#{closerow}"

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
				openrow = i % 5 == 0 ? " <div class='row stats statdata'>" : ""
				cssclass = "#{a.name}".strip
				cellopenid="<div class='col-sm-2'>"
				colautoopenid="<div class='col-sm-9 heading #{cssclass}'>"
				colsmallopenid="<div class='col-sm-3 rating #{cssclass}'>"
				cellcloseid='</div>'
				if ( (i > 0 ) && ( (i+1) % 5 == 0) )
					closerow = '</div>'
				else
				    closerow =''
				end
				title = "<span class='statname' title='#{correcttitle}: #{swdesc}'>#{correcttitle}</span>: "
				"#{openrow}#{cellopenid}#{title}#{rating}#{cellcloseid}#{closerow}"

				#Used for debugging - need to delete when complete
				#"#{downsizetitle} - #{swstats} - #{swdesc}<hr />"
			end
	end

	#Get the bennies for the website
	def self.returnbenniesforweb(bennies)
		bennies = "#{bennies}".to_i	
		if (bennies)
			return bennies
		else
			return "None"
		end
	end	
	
	#Get the conviction for the website
	def self.returnconvictionforweb(conviction)
		conviction = "#{conviction}".to_i	
		if (conviction)
			return conviction
		else
			return "None"
		end
	end
	
	
	#### CHARGEN ####

	def self.get_abilities_for_chargen(char)
		# Format Iconic Framework table
		swrifts_iconicf = Global.read_config('swrifts', 'iconicf')
		iconicf = returniconicforcg(swrifts_iconicf)
	
		if char.swrifts_iconicf
			chariconicf = char.swrifts_iconicf.titleize
		else
			chariconicf = ""
		end
		
		swrifts_race = Global.read_config('swrifts', 'races')			
		cgrace = returnraceforcg(swrifts_race)
		
		if char.swrifts_race
			charrace = char.swrifts_race.titleize
		else
			charrace = "Human"		
		end
		
		# Set up Chargen Points from Character not YML
		
		#cgpoints = returncgpforcg(char.swrifts_iconicf)
		cgpoints = char.swrifts_chargenpoints
		cgtraits = returncgpforcg(cgpoints)
		
		#iconicf='hellow world'
		#iconicf = swrifts_iconicf.join(" ") #removes the comma's that seperates the entries		

		#stats = returnstatsforweb(char.swrifts_stats)
		#stats = stats.join(" ") #removes the comma's that seperates the entries

		#bennies = returnbenniesforweb(char.swrifts_bennies)


		#conviction = returnconvictionforweb(char.swrifts_conviction)
		#conviction = conviction.join(" ") #removes the comma's that seperates the entries

		return {
		  iconicf: iconicf,
		  chariconicf: chariconicf,
		  cgrace: cgrace,
		  charrace: charrace,
		  cgpoints: cgtraits,
		  #stats: stats,
		  #bennies: bennies,
		  #conviction: conviction
		} 
	end	
	
	def self.returniconicforcg(model)
		iconicfarray = Array.new
        list = model.sort_by { |a| a['name']}
		list.each do |c|
			ifname = c['name']
			desc = c['description']
			ifstring = "#{ifname}"
			book = c['book_reference']
			if book
				ifstring << " ~ ("
				ifstring << book
				ifstring << ")"
			end			
			iconicfarray.push("#{ifstring}")
		end
		return (iconicfarray)
	end	
	
	def self.returnraceforcg(model)
		racearray = Array.new
        list = model.sort_by { |a| a['name']}
		list.each do |c|
			racename = c['name']
			desc = c['desc']
			book = c['book_reference']
			racestring = "#{racename}"
			
			if desc || book 
				racestring << " ~ "
			end
			
			if desc
				racestring << " "
				racestring << desc
			end
			
			if book
				racestring << " ("
				racestring << book
				racestring << ")"
			end
			racearray.push("#{racestring}")
		end
		return (racearray)
	end
	
	def self.returncgpforcg(cg)
		cgpointsarray = Array.new
		cgpoints =''
		#downsizetitle = chariconicf.downcase.strip!	
		#cg = Global.read_config('swrifts', 'iconicf')
		#cg = cg.sort_by { |a| a['name']}
		cg.each do |c|
			# cname = c['name'].downcase
			# cgpoints = c['chargen_points']
			# if ("#{cname}" == "#{downsizetitle}")
				cgpointsarray.push [name: c.name, points: 99]
				# cgpointsarray.push(cgacl)
			# end
			#cgpoints << "#{c.name} - #{c.rating}"
		end
		#return ("#{cgpoints}")
		return (cgpointsarray)
	end		
	
  end

end