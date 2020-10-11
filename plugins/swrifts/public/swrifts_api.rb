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
		ifstring=''
		if ( charicf.length > 0 )
			# get the entry in global file that matches the ICF name selected. We're going to make this pretty.
			charcgicf = swrifts_iconicf.select { |ss| ss['name'].downcase == charicf.downcase }.first
			ifname = charcgicf['name']
			desc = charcgicf['description']
			ifstring = "#{ifname}"
			book = charcgicf['book_reference']
			if book
				ifstring << " ~ ("
				ifstring << book
				ifstring << ")"
			end	
			charicf="#{ifstring}"
		else
			charicf="None"
		end
	
		
		swrifts_race = Global.read_config('swrifts', 'races')			
		cgrace = returnraceforcg(swrifts_race)
		initracepoints = returninitraceforcg(swrifts_race)
		
		# Get the Characters Race
		swriftstraits = char.swrifts_traits		
		charrace = acl_return_traits(swriftstraits,'race') #Get the characters Race from the traits		
		if ( charrace.length > 0 && charrace.downcase != "none" )
			# get the entry in global file that matches the ICF name selected. We're going to make this pretty.
			charcgrace = swrifts_race.select { |ss| ss['name'].downcase == charrace.downcase }.first
			newcgr = charcgrace.inspect
			if ( charcgrace ) 
				racename = charcgrace['name']
				desc = charcgrace['desc']
				book = charcgrace['book_reference']
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
			end
			charrace = "#{racestring}"
		else
			charrace = "None"		
		end
		
		# Set up Chargen Points from Character not YML
		cgpoints = char.swrifts_chargenpoints
		cgtraits = returncgpforcg(cgpoints)
		
		#Get the Edges that were set on the character.
		# cgedges = char.swrifts_edges
		# cgsysedges = Global.read_config('swrifts', 'edges')	
		# cgedg = returnedgesforcg(cgedges,cgsysedges)
		

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
		  #cgedges: cgedges,
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
	
	def self.returnedgesforcg(cg, cgsys)
		return ['']
		cgedgearray = []
		cgp = ''
		cg.each do |c|
				cgname = c.name
				edgsel = c.select { |ss| ss['name'].downcase == icf_downcase }.first #Filter the icf's to find the one that's been selected				
				cgn = cgname.gsub("_", " ")
				cgname = cgn.titleize				
				cgrating = c.rating
				cgpointsarray << {class: c.name, name: cgname, rating:cgrating}
		end
		return (cgedgearray)
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
		
		init = Global.read_config('swrifts', 'init')
					
		
		#Get the iconic framework and race set on the form
		c_iconicf = chargen_data[:custom][:iconicf]
		c_race = chargen_data[:custom][:race]


		#Remove the book and description stuff from the end of the string.	
		chopped_iconicf = c_iconicf[/[^~]+/]
		chopped_iconicf = chopped_iconicf
		chopped_iconicf = Website.format_input_for_mush(chopped_iconicf)
		chopped_race = c_race[/[^~]+/]
		chopped_race = chopped_race
		chopped_race = Website.format_input_for_mush(chopped_race)
		icf_downcase = chopped_iconicf.downcase.strip  # Stripped and downcased iconicframework name.
		race_downcase = chopped_race.downcase.strip  # Stripped and downcased race name.

		# Is this needed anymore? Leaving it jic.
		charif = Swrifts.get_iconicf(char, icf_downcase)		
		swriftstraits = char.swrifts_traits
		ischaricf = self.acl_return_traits(swriftstraits,'charif') #Get the characters Iconic Framework from the traits
		icfsize = ischaricf.size
		
		if (ischaricf.size > 0 )
			tt1 = "YES!!! Size: #{icfsize}"
		else
			tt1 = 'No :('
		end

		## ----- Update Iconic Framework
		
			char.delete_swrifts_chargen #clear out the character
			
			iconicf = Global.read_config('swrifts', 'iconicf') #Read the config file for Iconic Frameworks
			icfsel = iconicf.select { |ss| ss['name'].downcase == icf_downcase }.first #Filter the icf's to find the one that's been selected	
			tt = Swrifts.run_init(char, init)  #Calls run_init in helpers.rb
			trait = Swrifts.find_traits(char, 'iconicf')   #Calls find_traits in helpers.rb				
			trait.update(rating: icf_downcase)  #Update the Icf with the one chosen.
			tt1 = Swrifts.run_iconicf(char, icfsel) #Set the base stats based on the ICF chosen.		 
	
		return
	
	end
	
  end

end