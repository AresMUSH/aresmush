module AresMUSH
  module Swrifts
    include CommandHandler
	
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

		# Get the base CGen slots that might be filled
		swrifts_init = Global.read_config('swrifts', 'init')
		cgslots = returncgslotsforcg(swrifts_init)
		
		# Format Iconic Framework table
		swrifts_iconicf = Global.read_config('swrifts', 'iconicf')
		iconicf = returniconicforcg(swrifts_iconicf)
		initcgpoints = returninitcgforcg(swrifts_iconicf)
	
		# Get the Characters Iconic Framework
		swriftstraits = char.swrifts_traits		
		charicf = acl_return_traits(swriftstraits,'iconicf') #Get the characters Iconic Framework from the traits
		
		# if char.swrifts_iconicf
			# chariconicf = char.swrifts_iconicf.titleize
		# else
			# chariconicf = ""
		# end
		
		if charicf
			charicf=charicf
		else
			charicf="None"
		end
	
		
		swrifts_race = Global.read_config('swrifts', 'races')			
		cgrace = returnraceforcg(swrifts_race)
		initracepoints = returninitraceforcg(swrifts_race)
		
		# Get the Characters Race
		swriftstraits = char.swrifts_traits		
		charrace = acl_return_traits(swriftstraits,'race') #Get the characters Race from the traits		
		if charrace
			charrace = charrace
		else
			charrace = "None"		
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
		  # chariconicf: chariconicf,
		  charicf: charicf,
		  cgrace: cgrace,
		  charrace: charrace,
		  cgpoints: cgtraits,
		  inicgpoints: initcgpoints,
		  cgslots: cgslots,
		  initracepoints: initracepoints,
		  #stats: stats,
		  #bennies: bennies,
		  #conviction: conviction
		} 
	end	
	
	def self.returncgslotsforcg(model)
		# cginitarray = Hash.new #We're going to pass this back to the char custom fields.
		list = model['chargen_points'] #only get the chargen points
		# i = 0
		cginitarray = []
		cgp = ''
		list.each do |key, value|
				cgname = key
				cgn = cgname.gsub("_", " ")
				cgname = cgn.titleize				
				cginitarray << {class: key, name: cgname, rating:value}
		end
		return (cginitarray)
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
		iconicfarray.unshift("None")
		return (iconicfarray)
	end	
	
	def self.returninitcgforcg(model)
		initcgpointsarray = [] #We're going to pass this back to the char custom fields.
		d = Array.new #initialise the array we're going to use to pull the cgen points from.
		list = model.sort_by { |a| a['name']} #sort the iconic frameworks by name
		list.each do |c|  # roll through the if's 
				d = c['chargen_points'] # d is now an array of points set at the time of init
				n = c['name'] # This is the name of iconic frame.
				if (d)  # Are there any cgen points with this if?
					d.each do |key, rating|  # loop through the cgen points 
						ifname = n.downcase  #set name to all lowercase for ease of testing later
						initcgpointsarray << {ifname: ifname, name: key, rating: rating}  # set the hash 
					end
				end
		end
		return (initcgpointsarray) #return the complete hash.
	end

	def self.returninitraceforcg(model)
		initcgpointsarray = [] #We're going to pass this back to the char custom fields.
		d = Array.new #initialise the array we're going to use to pull the cgen points from.
		list = model.sort_by { |a| a['name']} #sort the race by name
		list.each do |c|  # roll through the races 
				d = c['chargen_points'] # d is now an array of points set at the time of init
				n = c['name'] # This is the name of iconic frame.
				if (d)  # Are there any cgen points with this if?
					d.each do |key, rating|  # loop through the cgen points 
						ifname = n.downcase  #set name to all lowercase for ease of testing later
						initcgpointsarray << {ifname: ifname, name: key, rating: rating}  # set the hash 
					end
				end
		end
		return (initcgpointsarray) #return the complete hash.
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
		racearray.unshift("None")
		return (racearray)
	end
	
	def self.returncgpforcg(cg)
		cgpointsarray = []
		cgp = ''
		cg.each do |c|
				cgname = c.name
				cgn = cgname.gsub("_", " ")
				cgname = cgn.titleize				
				cgrating = c.rating
				cgpointsarray << {class: c.name, name: cgname, rating:cgrating}
		end
		return (cgpointsarray)
	end	
	
	def self.acl_return_traits(st,traitname)
	traitname = traitname.downcase
	txtstring = ''
	st.to_a.sort_by { |a| a.name }
		.each_with_index
			.map do |a, i| 
			if a.name.downcase == "#{traitname}"
				return ("#{a.rating}")
			end
		end	
	end	
	
	def self.save_abilities_for_chargen(char, chargen_data)		

		if (!chargen_data[:custom]) 
			return ["No Custom Data"]
		end
		
		#Get the iconic framework and race set on the form
		c_iconicf = chargen_data[:custom][:iconicf]
		c_race = chargen_data[:custom][:race]


		#Remove the book and description stuff from the end of the string.	
		chopped_iconicf = c_iconicf[/[^~]+/]
		chopped_iconicf = Website.format_input_for_mush(chopped_iconicf)
		chopped_race = c_race[/[^~]+/]
		chopped_race = Website.format_input_for_mush(chopped_race)
		name_downcase = chopped_iconicf.downcase  # Work out how to cycle through the custom stuff for this. Keep it tight.
		
		swriftstraits = char.swrifts_traits
		ischaricf = self.acl_return_traits(swriftstraits,'iconicf') #Get the characters Iconic Framework from the traits
		icfsize = ischaricf.size
		if (ischaricf.size > 0 )
			tt1 = "YES!!! Size: #{icfsize}"
		else
			tt1 = 'No :('
		end

		## ----- Update Iconic Framework
		


			if ( ischaricf.size == 0  )
				# swinit = Global.read_config('swrifts', 'init')
				tt = SwriftsTraits.create(name: 'iconicf', rating: name_downcase, character: char)
				# if (swinit['traits']) 
					# traits = swinit['traits']
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					# traits.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						# setthing = key.downcase
						# alias the 'rating' for the same reason
						# setrating = rating
						# SwriftsTraits.create(name: setthing, rating: setrating, character: char)
					# end	
				# end
				##trait = char.swrifts_traits.select { |a| a.name.downcase == name_downcase }.first				
				##tt = trait.update(rating: name_downcase)
				tt2 = 'we got here'
			else
				tt = SwriftsTraits.update(name: 'iconicf', rating: name_downcase, character: char)
				tt2 = "updated"
			end
		 # end 
		 
		# trait = char.swrifts_traits.inspect
	
		return ["Trait: #{ischaricf}, #{tt1}, #{tt2}"]
		

		
		# client.emit_success ("Iconic Framework Added")		
		#char.update(swrifts_iconicf: Website.format_input_for_mush(chopped_iconicf), swrifts_race: Website.format_input_for_mush(chopped_race));
		
        #return ["Iconfic Framework Set to: #{chopped_iconicf}", "Race set to: #{chopped_race}"]	
	end
	
  end

end