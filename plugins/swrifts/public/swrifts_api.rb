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
		
		# Get the Characters Traits	
		swrifts_iconicf = Global.read_config('swrifts', 'iconicf')
		swrifts_race = Global.read_config('swrifts', 'races')			
	
		swriftstraits = char.swrifts_traits	
		charicf = acl_return_traits(swriftstraits,'iconicf') #Get the characters Iconic Framework from the traits		
		charrace = acl_return_traits(swriftstraits,'race') #Get the characters Race from the traits			
		
		cgedges = char.swrifts_edges
		cgsysedges = Global.read_config('swrifts', 'edges')
		cghinder = char.swrifts_hinderances
		cgsyshind = Global.read_config('swrifts', 'hinderances')
	
		# Set the Characters Iconic Framework
		if ( charicf.length > 0 )
			charicf = getcharicf(charicf,swrifts_iconicf)
		else
			charicf="None"
		end
		
		# Set the Characters Race			
		if ( charrace.length > 0 && charrace.downcase != "none" )
			charrace = getcharrace(charrace,swrifts_race)
		else
			charrace = "None"		
		end
		
		# Format Iconic Framework table
		iconicf = returniconicforcg(char, swrifts_race, charrace, swrifts_iconicf)
		initcgpoints = returninitcgforcg(swrifts_iconicf)	
		
		#Get the race list for drop down.
		cgrace = returnraceforcg(char, swrifts_race, charicf, swrifts_race)		
		initracepoints = returninitraceforcg(swrifts_race)
		
		# Set up Chargen Points from Character not YML
		cgpoints = char.swrifts_chargenpoints
		cgtraits = returncgpforcg(cgpoints)
		
		#Get the Edges that were set on the character.
		fw = "all"
		cgedg = returnedgesforcg(cgedges,cgsysedges, fw)
		fw = "nofw"
		cgedgnofw = returnedgesforcg(cgedges,cgsysedges, fw)		

		
		#Get the hinderances that were set on the character.
		fw = "all"
		cghind = returnedgesforcg(cghinder,cgsyshind, fw)
		fw = "nofw"
		cghindnofw = returnedgesforcg(cghinder,cgsyshind, fw)
		

		#Get the System Edges
		sysedges = returnsysedgesforcg(cgsysedges, cgedges)			
		
		#Get the System Hinderances
		syshind = returnsysedgesforcg(cgsyshind, cghinder)		

		return {
		  iconicf: iconicf, #System iconic frameworks
		  sysiconicf: swrifts_iconicf, # Full System iconic frameworks
		  charicf: charicf, #Character Iconic Framework
		  swrifts_race: swrifts_race, #Just get the whole Race YML, looks like we're going to need it.
		  cgrace: cgrace, #System races
		  charrace: charrace, #Char Race
		  cgpoints: cgtraits, #CG points for the character
		  inicgpoints: initcgpoints, #CG points set by system.
		  cgslots: cgslots,
		  initracepoints: initracepoints,
		  cgedges: cgedg, #Edges on Character
		  cghind: cghind, #Hinderances on Character
		  cgedgesnofw: cgedgnofw, #Edges on Character for framework stuff
		  cghindnofw: cghindnofw, #Hinderances on Character for framework stuff
		  sysedges: sysedges, #Edges from system
		  swsyshind: syshind, #Hinderances from system
		} 
	end	
	
	def self.getcharicf(charicf,swrifts_iconicf) 
		cifstring = Array.new
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
		cifstring = {class: ifname, name: ifstring, rating: desc}
		return (cifstring)
	end	
	
	def self.getcharrace(charrace,swrifts_race) 
		# get the entry in global file that matches the ICF name selected. We're going to make this pretty.
		cracestring = Array.new
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
		cracestring << {class: racename, name: racestring, rating: desc}		
		return (cracestring)
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
	
	def self.returniconicforcg(char, swrifts_race, charrace, model)
		iconicfarray = []
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
			ifdisabled=false # Will need better logic here.
			
			# Is there a character race selected?
			if ( charrace.length > 0 && charrace.downcase != "none" )	
				rc = Swrifts.race_check(char, swrifts_race, charrace, ifname)
				if (rc == true) 
					ifdisabled = true
				end
			end		
			iconicfarray << {name: ifstring, disabled: ifdisabled, desc: desc}
		end
		blankstrg = {name: 'None ~ Select to reset Iconic Framework', disabled: false, desc: 'Choose to reset Iconic Framework'}
		iconicfarray.unshift(blankstrg)
		return (iconicfarray)
	end	
	  
	#This is used for Edges and Traits. 
	
	def self.returnsysedgesforcg(cgsys, cg)
		iconicfarray = []	
        list = cgsys.sort_by { |a| a['name']}
		list.each do |c|
			ifname = c['name']
			ifnamedowncase = ifname.downcase
			desc = c['description']
			
			if (cg)
				edgsel = cg.select { |ss| ss.name.downcase.start_with?"#{ifnamedowncase}" }.first #Filter the icf's to find the one that's been selected
			end

			if (edgsel)
				edgselname = edgsel.name.gsub("^", "*")
				if (!edgselname.include?("*"))
					ifstring = "#{ifname}"
					ifdisabled = false
				else
					ifstring = "#{ifname}"
					ifdisabled = true
				end
			else
				ifstring = "#{ifname}"
				ifdisabled = false
			end
			iconicfarray << {name: ifstring, disabled: ifdisabled, desc: desc}
		end
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
	
	def self.returnraceforcg(char, swrifts_race, ifname, model)
		racearray = []
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
			
			ifdisabled=false # Will need better logic here.
			ifname = 'mystic'
			# Is there a character race selected?
			if ( ifname.length > 0 && ifname != "none" )	
				rc = Swrifts.race_check(char, swrifts_race, racename, ifname)
				if (rc == true) 
					ifdisabled = true
				end
			end			
			racearray << {name: racestring, disabled: ifdisabled, desc: desc, class: racename}
						
		end
		blankstrg = {name: 'None ~ Select to reset Race', disabled: false, desc: 'Choose to reset Race', class: 'none'}
		racearray.unshift(blankstrg)
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
	
	def self.returnedgesforcg(cg, cgsys, fw)
		cgedgearray = []
		cgp = ''
		
		if (fw == 'all')
			cg.each do |c|
					cgname = "#{c.name}"
					cgname = cgname.downcase
					cgname = cgname[/[^*]+/]
					cgname = cgname[/[^^]+/]
					cgname = cgname.strip
					edgsel = cgsys.select { |ss| ss['name'].downcase == cgname.downcase }.first #Filter the icf's to find the one that's been selected	
					if (edgsel)
						cgdesc = edgsel['description']
					end
					cgedgearray << {class: c.name, name: cgname, rating: cgdesc}
			end
		end
		
		if (fw == "nofw")
			cg.each do |c|
				cgname = "#{c.name}"
				cgname = cgname.downcase
				cgnamesub = cgname.gsub("^", "*")
				if (!cgnamesub.include?("*"))
					cgname = cgname[/[^*]+/]
					cgname = cgname[/[^^]+/]
					cgname = cgname.strip
					edgsel = cgsys.select { |ss| ss['name'].downcase == cgname.downcase }.first #Filter the icf's to find the one that's been selected	
					if (edgsel)
						cgdesc = edgsel['description']
					end
					cgedgearray << {class: c.name, name: cgname, rating: cgdesc}
				end
			end
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
		dbgstr = ''	
		
		#Get the iconic framework and race set on the form
		c_iconicf = chargen_data[:custom][:iconicf]
		c_race = chargen_data[:custom][:race]
		c_edges = chargen_data[:custom][:cgedges]
		c_edgesnofw = chargen_data[:custom][:cgedgesnofw]
		c_hind = chargen_data[:custom][:cghind]
		c_hindnofw = chargen_data[:custom][:cghindnofw]


		#Remove the book and description stuff from the end of the string.	
		chopped_iconicf = c_iconicf[/[^~]+/]
		chopped_iconicf = Website.format_input_for_mush(chopped_iconicf)
		chopped_race = c_race[/[^~]+/]
		chopped_race = Website.format_input_for_mush(chopped_race)
		icf_downcase = chopped_iconicf.downcase.strip  # Stripped and downcased iconicframework name.
		race_downcase = chopped_race.downcase.strip  # Stripped and downcased race name.

		## ----- Update Iconic Framework
		
			char.delete_swrifts_chargen #clear out the character
			
			
			#Set the iconic framework
			iconicf = Global.read_config('swrifts', 'iconicf') #Read the config file for Iconic Frameworks
			icfsel = iconicf.select { |ss| ss['name'].downcase == icf_downcase }.first #Filter the icf's to find the one that's been selected	
			tt = Swrifts.run_init(char, init)  #Calls run_init in helpers.rb
			tt1 = Swrifts.run_system(char, icfsel) #Set the base stats based on the ICF chosen.			
			trait = Swrifts.find_traits(char, 'iconicf')   #Calls find_traits in helpers.rb				
			trait.update(rating: icf_downcase)  #Update the Icf with the one chosen.
			
			
			#Set the Race
			racesys = Swrifts.find_race_config(race_downcase) #get the Race entry we're working with from the yml
			#rc = Swrifts.race_check(model, race, self.race_name, icf_name) # Checks if ICF and Race work together
			race_trait = Swrifts.find_traits(char, 'race')	 #get the Race trait off of the character
			race_trait.update(rating: race_downcase) #Update the race with the one chosen.

			#Save the no framework edges
			if (c_edgesnofw)  #If there are edges not related to the Iconic Framework and Race
				c_edgesnofw.each do |key,value|  #Cycle through each one
					edge_name = "#{value['name']}".downcase #set the name to all lowercase
					ss = Swrifts.add_feature(char, SwriftsEdges, "edges", edge_name) #Call the add_feature function helpers.rb
					dbgstr << "Edge name: #{edge_name}, #{ss}"  #For troubleshooting.
				end
			end
			
			#Save the no framework hinderance

			if (c_hindnofw) #If there are hinderances not related to the Iconic Framework and Race
				c_hindnofw.each do |key, value| #Cycle through each one
					edge_name = "#{value['name']}".downcase #set the name to all lowercase
					ss = Swrifts.add_feature(char, SwriftsHinderances, "hinderances", edge_name) #Call the add_feature function helpers.rb
					dbgstr << "Edge name: #{edge_name}, #{ss}" #For troubleshooting
				end
			end
	
		return (dbgstr)
	end
	
  end

end