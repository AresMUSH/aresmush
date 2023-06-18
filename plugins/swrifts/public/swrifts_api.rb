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

        bennies = returnbandcforweb(char.swrifts_counters, 'bennies')
        bennies = bennies.join(" ") #removes the comma's that seperates the entries

        conviction = returnbandcforweb(char.swrifts_counters, 'conviction')
        conviction = conviction.join(" ") #removes the comma's that seperates the entries

        charicf = returnicfforweb(char)
        charabils = returnabilitiesforweb(char)
		if (charabils )
	        charabils = charabils.join(" ") #removes the comma's that seperates the entries
		end

        charedges = returnedgesforweb(char,'edge')
        charedges = charedges.join(" ") #removes the comma's that seperates the entries

        charhind = returnedgesforweb(char,'hind')
        charhind = charhind.join(" ") #removes the comma's that seperates the entries

        return {
          skills: skills,
		  stats: stats,
          charicf: charicf,
          charabils: charabils,
          charedges: charedges,
          charhind: charhind,
		  bennies: bennies,
		  conviction: conviction,
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

	#Get the bennies and conviction for the website
	def self.returnbandcforweb(counters,trait)

    counters.each
      .map do | bb |
        if (trait == 'bennies')
          if (bb.name == 'bennies_current')
            title = "<span class='skillname'>Current Bennies:</span> <span class='rating'>#{bb.rating}</span><br />"
          elsif (bb.name == "bennies_max")
            title = "<span class='skillname'>Max Bennies:</span> <span class='rating'>#{bb.rating}</span>"
          end
        elsif (trait == 'conviction')
          if (bb.name == 'conviction_current')
            title = "<span class='skillname'>Current Conviction:</span> <span class='rating'>#{bb.rating}</span><br />"
          elsif (bb.name == "conviction")
            title = "<span class='skillname'>Max Conviction:</span> <span class='rating'>#{bb.rating}</span><br />"
          end
        end
    end
	end

  def self.returnicfforweb(char)
    swriftstraits = char.swrifts_traits
    rawcharicf = acl_return_traits(swriftstraits,'iconicf') #Get the characters Iconic Framework from the traits
    swrifts_iconicf = Global.read_config('swrifts', 'iconicf')
    mycharicf = getcharicf(rawcharicf,swrifts_iconicf)
    if ( rawcharicf.length > 0 )
      mycharicf = getcharicf(rawcharicf,swrifts_iconicf)
      title = "<p class='test'>#{mycharicf[:name]}: #{mycharicf[:rating]}</p>"
    else
      title="None"
    end
  end


  def self.returnabilitiesforweb(char)
    swriftstraits = char.swrifts_traits
    rawcharicf = acl_return_traits(swriftstraits,'iconicf') #Get the characters Iconic Framework from the traits
    swrifts_iconicf = Global.read_config('swrifts', 'iconicf')
    swrifts_abilities = Global.read_config('swrifts', 'abilities')

    # Set the Characters Iconic Framework
    if ( rawcharicf.length > 0 )
      mycharicf = getcharicf(rawcharicf,swrifts_iconicf)
      if ( mycharicf.length > 0 )
		if (mycharicf[:abilities])
			mycharicf[:abilities].each
			.map do | aa |
				aaname = aa.gsub("*", "")
				aaname = aaname.gsub("^", "")
				aadeets = swrifts_abilities.select { |ss| ss['name'].downcase == aaname.downcase }.first
				if ( aadeets )
					desc = aadeets['description']
				else
				desc = "better fill out the abilities file hmmm?"
				end
				title = "<p class='swabil'><span><strong>#{aa}</strong><br />#{desc}</span></p>"
			end
		end
      end
    end
  end


  def self.returnedgesforweb(char,trait)
    if (trait == 'edge')
      swrifts_trait = Global.read_config('swrifts', 'edges') #Get all the edges so we can grab the up to date descriptions
      chartraits = char.swrifts_edges #Get what's set on the Character
    elsif (trait == 'hind')
      swrifts_trait = Global.read_config('swrifts', 'hinderances') #Get all the hinderances so we can grab the up to date descriptions
      chartraits = char.swrifts_hinderances #Get what's set on the Character
    end

    chartraits.each
      .map do |c| #Loop through each edge on the character
        ctraitname = c.name.gsub("*","")
        ctraitname = ctraitname.gsub("^","")
        ctraitdeets = swrifts_trait.select { |ce| ce['name'].downcase == ctraitname.downcase }.first
        if ( ctraitdeets )
          desc = ctraitdeets['description']
        else
          desc = "Better fill out a desc, hmmmm?"
        end
        title = "<p class='swabil'><span><strong>#{ctraitname}</strong><br />#{desc}</span></p>"
    end
  end


#### CHARGEN ####

	def self.get_abilities_for_chargen(char)
		# Get the base CGen slots that might be filled
		swrifts_init = Global.read_config('swrifts', 'init')
		cgslots = returncgslotsforcg(swrifts_init)

####### This is probably not needed - I still have to calculate the points dynamically ####
		chargenpoints = char.swrifts_chargenpoints
		chargenpoints = acl_returncgpoints(chargenpoints)
#######

		# Get the Characters Traits
		swrifts_iconicf = Global.read_config('swrifts', 'iconicf')
		swrifts_race = Global.read_config('swrifts', 'races')
		swrifts_perks = Global.read_config('swrifts', 'perks')

		swriftstraits = char.swrifts_traits
		rawcharicf = acl_return_traits(swriftstraits,'iconicf') #Get the characters Iconic Framework from the traits
		rawcharrace = acl_return_traits(swriftstraits,'race') #Get the characters Race from the traits

		cgedges1 = char.swrifts_edges
		cgsysedges = Global.read_config('swrifts', 'edges')
		cghinder = char.swrifts_hinderances
		cgsyshind = Global.read_config('swrifts', 'hinderances')
		cghjtables = char.swrifts_heroesj

		# Set the Characters Iconic Framework
		if ( rawcharicf.length > 0 )
			charicf = getcharicf(rawcharicf,swrifts_iconicf)
		else
			charicf="None"
		end

		# Set the Characters Race
		# if ( rawcharrace.length > 0 && rawcharrace.downcase != "none" )
		if ( rawcharrace.length > 0 )
			charrace = getcharrace(rawcharrace,swrifts_race)
		else
			charrace = "None"
		end

		# Format Iconic Framework table
		iconicf = returniconicforcg(char, swrifts_race, rawcharrace, swrifts_iconicf)
		initcgpoints = returninitcgforcg(swrifts_iconicf)

		#Get the race list for drop down.
		cgrace = returnraceforcg(char, swrifts_race, rawcharicf, swrifts_race)
		initracepoints = returninitraceforcg(swrifts_race)

		# Set up Chargen Points from Character not YML
		cgpoints = char.swrifts_chargenpoints
		cgtraits = returncgpforcg(cgpoints)

		#Get the Edges that were set on the character.
		fw = "all"
		cgedg = returnedgesforcg(cgedges1,cgsysedges, fw, 'edge')
		fw = "nofw"
		cgedgnofw = returnedgesforcg(cgedges1,cgsysedges, fw, 'edge')
		fw = "fw"
		cgedgfw = returnedgesforcg(cgedges1,cgsysedges, fw, 'edge')


		#Get the hinderances that were set on the character.
		fw = "all"
		cghind = returnedgesforcg(cghinder,cgsyshind, fw, 'hind')
		fw = "nofw"
		cghindnofw = returnedgesforcg(cghinder,cgsyshind, fw, 'hind')
		fw = "fw"
		cghindfw = returnedgesforcg(cghinder,cgsyshind, fw, 'hind')


		#Get the System Edges
		sysedges = returnsysedgesforcg(cgsysedges, cgedges1, charicf, charrace, 'edge')

		#Get the System Hinderances
		syshind = returnsysedgesforcg(cgsyshind, cghinder, charicf, charrace, 'hind')

		hjslots = acl_get_hj_slots(swrifts_iconicf, rawcharicf) #swrifts_icf is the system icf's, charicf is the one selected by the player
		#hjslots = ("#{hjslots}");

		hjtables = acl_get_hj_tables(cghjtables, rawcharicf)
		# hjtables = hjtables.inspect

		#Get the Perk points set on the character
		charhindpoints = char.swrifts_perkpoints
		
		#Get the Perks saved to the character
		charperks = char.swrifts_charperks
		charperktable = acl_get_charperks(swrifts_perks, cghjtables, charperks)
		charperks = ("#{charperktable}")

		return {
		  iconicf: iconicf, #System iconic frameworks
		  sysiconicf: swrifts_iconicf, # Full System iconic frameworks
		  charicf: charicf, #Character Iconic Framework
		  swrifts_race: swrifts_race, #Just get the whole Race YML, looks like we're going to need it.
		  cgrace: cgrace, #System races
		  charrace: charrace, #Char Race
		  cgpoints: cgtraits, #CG points for the character
		  inicgpoints: initcgpoints, #CG points set by system.
		  cgslots: cgslots, #CG points set at init
		  cgpoints: chargenpoints, #Get the cgpoints that are stored on the character sheet
		  initracepoints: initracepoints,
		  cgedges: cgedg, #Edges on Character
		  cghind: cghind, #Hinderances on Character
		  cgedgesnofw: cgedgnofw, #Edges on Character for framework stuff
		  cgedgesfw: cgedgfw, #Only Framework Edges on Character for framework stuff
		  cghindnofw: cghindnofw, #Hinderances on Character for framework stuff
		  cghindfw: cghindfw, #Only framework Hinderances on Character for framework stuff
		  sysedges: sysedges, #Edges from system
		  syshind: syshind, #Hinderances from system
		  hjslots: hjslots,
		  hjtables: hjtables,
      	  charperks: charperks, #The perks set on the character
		  charhindpoints: charhindpoints, #The number perks points calculated from the hinderances selected
		  swperks: swrifts_perks
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
    	abilities = charcgicf['abilities']
		if book
			ifstring << " ~ ("
			ifstring << book
			ifstring << ")"
		end
		cifstring = {class: ifname, name: ifstring, rating: desc, bookref: book, abilities:abilities}
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
		cracestring = {class: racename, name: racestring, rating: desc}
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

	def self.returniconicforcg(char, swrifts_race, rawcharrace, model)
    # char: Character
    # swrifts_race: All Races
    # rawcharrace: Character Race
    # model: All ICFs
		iconicfarray = []
		newtt =''
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
			if ( rawcharrace.length > 0 )
				swrifts_race = Swrifts.find_race_config(rawcharrace) #get the Race entry we're working with from the yml

        #Check the race to make sure it can use this stuff.
				rc = Swrifts.race_check(char, swrifts_race, rawcharrace, ifname)
        #return ("#{rc}")
				if (rc == true)
					ifdisabled = true
				end
			end
			iconicfarray << {name: ifstring, disabled: ifdisabled, desc: desc, class: ifname}
		end
		blankstrg = {name: 'None ~ Select to reset Iconic Framework', disabled: false, desc: 'Choose to reset Iconic Framework', class: "none"}
		iconicfarray.unshift(blankstrg)
		return (iconicfarray)
	end

	#This is used for Edges and Traits.

	def self.returnsysedgesforcg(cgsys, cg, charicf, charrace, traittype)
		#cgsys = System Traits
		#cg = character traits
		#charicf = ICF Chosen
		#charrace = Race Chosen
		#traittype = Edge or Hinderance

		iconicfarray = []
		ttss = []
		whatsthis = []
		ttsl = []
    whatthis = []

		# Create an array of the excluded traits for the ones that are already set on the character.
		cg.each do |d|
			ttsl << { name: "#{d.name}" }
			dname = d.name.downcase
			dname = dname.gsub("*", "")
			dname = dname.gsub("^", "")
			trexlarray = cgsys.select { |ss| ss['name'].downcase.start_with?"#{dname}" }.first #Filter the trait's to find the one that's been selected

			if ( trexlarray )
				if ( traittype == 'hind' )
					if ( trexlarray['excludes'] )
						trex = trexlarray['excludes']
						if ( trex.length > 0 )
							trex.each do |t|
								ttss << { name: "#{dname}", exclude: "#{t}" } #Make an object that has the name of the Hinderance and what it excludes.
							end
						end
					end
				else
					trex = ''
					if ( trexlarray['pre-reqs'] )
						preqs = trexlarray['pre-reqs']
						if ( preqs.length > 0 )
							prearray = preqs.select { |ss| ss['iconicf'] }
							if ( prearray.length > 0 )
								prearray.each do |t|
									ttss << { icfex: "#{t['iconicf']}" }
									# If the ICF chosen by the player doesn't match t['iconicf'] then remove this trait from the main array (cg).
									if ( charicf[:class].downcase != t['iconicf'].downcase )
										d.delete
									end
								end
							end
							prearray = preqs.select { |ss| ss['race'] }
							if ( prearray.length > 0 )
								prearray.each do |t|
									ttss << { raceex: "#{t['race']}" }
									# If the Race chosen by the player doesn't match t['race'] then remove this trait from the main array (cg).
									if ( charrace[:class].downcase != t['race'].downcase )
										d.delete
									end
								end
							end
						end
					end
				end
			end
		end

    list = cgsys.sort_by { |a| a['name']} #convert the system traits (that's whole honking lot of them) to an array and sort by name.

		list.each do |c| #cycle through the array so we can set the appropriate ones to disabled
			ifdisabled = false
			ifname = c['name']
			ifnamedowncase = ifname.downcase
			desc = c['description']

			if ( traittype == 'hind' )
				# Go through excluded hinderances and mark them as disabled
				trexcludes = ''
				if ( ttss.length > 0)
  					incg = ttss.select { |ss| ss[:exclude].downcase == ifnamedowncase }
					if ( incg.length > 0 )
						incg.each do |ic|
							ifdisabled = true
							trexcludes = c['excludes']
						end
					else
            if ( c['excludes'] )
  					  trexcludes = c['excludes']
            else
              trexcludes = ''
  					end
          end
        else
          if ( c['excludes'] )
            trexcludes = c['excludes']
          else
            trexcludes = ''
          end
				end
        hindpoints = c['hind_points']
			elsif ( traittype == 'edge' && c['pre-reqs'] )
				trex = ''
				preqs = c['pre-reqs']
				trexcludes = ''
				if ( preqs.length > 0 )
					prearray = preqs.select { |ss| ss['iconicf'] }
					if ( prearray.length > 0 )
						prearray.each do |t|
							# If the edge requires a specific ICF and that's not chosen, then disable it.
							if ( charicf[:class].downcase != t['iconicf'].downcase )
								if ( t['iconicf'].length > 0 )
									trexcludes = t['iconicf']
								else
									trexcludes = ''
								end
								ifdisabled = true
							end
						end
					end
					prearray = preqs.select { |ss| ss['race'] }
					if ( prearray.length > 0 )
						prearray.each do |t|
							# If the Race chosen by the player doesn't match t['race'] then remove this trait from the main array (cg).
							if ( charrace[:class].downcase != t['race'].downcase )
								if ( t['race'].length > 0)
									trexcludes = t['race']
								else
									trexcludes = ''
								end
								ifdisabled = true
							end
						end
					end
				end
        hindpoints = 0
			else
				trexcludes = ''
        hindpoints = 0
			end

			#Now we do this the other way. Find if the current trait has been selected by the player and mark it disabled from selection
			cg.each do |d|
				dname = d.name.downcase
				dname = dname.gsub("*", "")
				dname = dname.gsub("^", "")
				if ( dname == ifnamedowncase )
					ifdisabled = true
				end
			end

			iconicfarray << {name: ifname, disabled: ifdisabled, desc: desc, trexcludes: trexcludes, hind_points: hindpoints }
		end

		return ( iconicfarray )
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
		# char: character
    # swrifts_race: system races
    # ifname: rawcharicf
    # model: system races (again?)
    # return ( "Swrifts race: #{swrifts_race} ifname: #{ifname} model: #{model}" )
    #return ( "Swrifts race: #{swrifts_race}" )
		racearray = []
    list = model.sort_by { |a| a['name']} #sort the system icf or race by name.
		list.each do |c| #loop though the list and assign the variables needed.
			racename = c['name'];
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
			swrifts_race = Swrifts.find_race_config(racename) #get the Race entry we're working with from the yml
			# Is there a character icf selected?
			if ( ifname.length > 0 && ifname != "none" )
				rc = Swrifts.race_check(char, swrifts_race, racename, ifname)
				if (rc == true)
					ifdisabled = true
				end
			end

			racearray << {name: racestring, disabled: ifdisabled, desc: desc, class: racename}

		end
		blankstrg = {name: "None ~ Select to reset Race", disabled: false, desc: 'Choose to reset Race', class: 'none'}
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

	def self.returnedgesforcg(cg, cgsys, fw, traittype)
		acldb = false
		### Passed in elements ###
		## cg = character traits
		## cgsys = systemtraits
		##########################
		cgedgearray = []
		cgp = ''
		testret = []

		if ( acldb )
			# cg.each do |c|
				# cgedgearray << {class: c.name}
			# end
			# cgedgearray << {name: 'ne', disabled: 'false', class: 'you', rating: 'desc', trexcludes: 'false'}
			# return (cgedgearray.inspect)
		else
			if (fw == 'all')
				cg.each do |c|
						cgname = "#{c.name}"
						#cgname = cgname.downcase
						cgname = cgname[/[^*]+/]
						cgname = cgname[/[^^]+/]
						cgname = cgname.strip
						edgsel = cgsys.select { |ss| ss['name'].downcase == cgname.downcase }.first #Filter the traits's to find the one(s) that have been selected
						if (edgsel)
							cgdesc = edgsel['description']
							cgpoints = edgsel['hind_points']
							if ( traittype == 'hind' && edgsel['excludes'])
								trexcludes = edgsel['excludes'];
							else
								trexcludes = 'false';
							end
						end
						cgedgearray << {name: cgname, disabled: 'false', class: c.name, rating: cgdesc, points: cgpoints, trexcludes: trexcludes}
				end
			end

			if (fw == "nofw")
			trdisabled = false
			# CG = character traits, cgsys = systemtraits.
				cg.each do |c|
					cgname = "#{c.name}"
					#cgname = cgname.downcase
					cgnamesub = cgname.gsub("^", "*")
					trexcludes = 'kkkkk'
					if (!cgnamesub.include?("*"))
						cgname = cgname[/[^*]+/]
						cgname = cgname[/[^^]+/]
						cgname = cgname.strip
						edgsel = cgsys.select { |ss| ss['name'].downcase == cgname.downcase }.first
						if (edgsel)
							cgdesc = edgsel['description']
							cgpoints = edgsel['hind_points']
							trdisabled = true;
							if ( traittype == 'hind' && edgsel['excludes'])
								trexcludes = edgsel['excludes'];
							else
								trexcludes = 'false';
							end
						else
							trexcludes = 'false';
						end
						cgedgearray << {name: cgname, disabled: trdisabled, class: c.name, rating: cgdesc, points: cgpoints, trexcludes: trexcludes }
					end
				end
			end

			if (fw == "fw")
			trdisabled = false
			# CG = character traits, cgsys = systemtraits.
				cg.each do |c|
					cgname = "#{c.name}"
					#cgnamenew = cgname.downcase
					cgnamesub = cgname.gsub("^", "*")   #Trying to find out why the ^ are repeated
					if (cgnamesub.include?("*"))
						cgnamenew = cgname[/[^*]+/]
						cgnamenew = cgname[/[^^]+/]
						cgnamenew = cgname.strip
						edgsel = cgsys.select { |ss| ss['name'].downcase == cgnamenew.downcase }.first #Filter the icf's to find the one that's been selected
						if (edgsel)
							cgdesc = edgsel['description']
							trdisabled = true;
							if ( traittype == 'hind' && edgsel['excludes'])
								trexcludes = edgsel['excludes'];
							else
								trexcludes = 'false';
							end
						end
						cgedgearray << {name: cgname, disabled: trdisabled, class: c.name, rating: cgdesc, trexcludes: trexcludes}
					end
				end
			end
		end
		#return ("#{cgedgearray}")
		return (cgedgearray)
	end

  def self.acl_get_hj_slots(swrifts_iconicf, charicf) 
		#swrifts_icf is the system icf's
		#charicf is the one selected by the player

		# attribute :name #hj1, hj2, etc.
		# attribute :rating, :type => DataType::Integer #the random roll
		# attribute :table #Body Armor, etc.
		# attribute :description #text from table
		# reference :character, "AresMUSH::Character"


		if charicf #has there an ICF selected?
			cifstring = Hash.new
			tempcifstring = []

			charcgicf = swrifts_iconicf.select { |ss| ss['name'].downcase == charicf.downcase }.first
			# get the entry in global file that matches the ICF name selected. We're going to make this pretty.
			pattern = 'hj'
			charhjicf = charcgicf.select{ |k,v| k[pattern] }
			if (charhjicf.length > 0)
				charhjicf.each do |k,v|
					tempcifstring = []
					hjopt = k.split("_")[0]
          			hjname = hjopt.gsub("hj","")
					v.each do |k1,v1|
						tempcifstring << {table: k1, name: hjopt, tablename: hjname}
					end
					cifstring[hjopt] = tempcifstring
				end
			end
		end
		return (cifstring);
	end

	def self.acl_get_hj_tables(hjtables, charicf) #hjtables is the HJ's set on the char, charicf is the one selected by the player (not used)
	 	txtstring = []
	 	hjstr = []
	 	tempcifstring =  Hash.new

	 	hjstring = hjtables.to_a.sort_by { |a| a.name }
	 		.each_with_index
	 			.map do |a, i|
	 				tempcifstring[a.name] = {table: a.table, name: a.name}
	 			end
	 	return (tempcifstring)
	 end

	 def self.acl_get_charperks(swperks, cghjtables, perktable) 
		#perktable is the Perks set on the char
		#swperks is the system perks
		### End array should look like: ###
		#perkname: An integer
		#name: The name of the Perk
		#cost: the cost of the perk

		return (cghjtables)
		txtstring = []
		perkstr = []
		tempperkstring =  Hash.new
		x = 0

		perkstring = swperks.to_a.sort_by { |a| a.name }
			.each_with_index
				.map do |a, i|
					ctr = x+1
					perkname = "Perk #{ctr}"
					tempperkstring[perkname] = {name: a.name, cost: a.cost, perknumber: ctr }
				end
		return (tempperkstring)
	end	 

	def self.acl_return_traits(st,traitname) #st is the traits pulled from the character. traitname is whether we want the ICF traits or Race Traits or perks.
		traitnamedc = traitname.downcase
		txtstring = ''
		st.to_a.sort_by { |a| a.name }
			.each_with_index
				.map do |a, i|
				if a.name.downcase == "#{traitnamedc}"
					return ("#{a.rating}")
				end
			end
	end

	# def self.acl_get_charperk_slots(swrifts_iconicf, charicf) #swrifts_icf is the system icf's, charicf is the one selected by the player

	# 	# attribute :name #Raise an Edge, Raise a Skill, Add an Edge, etc.
	# 	# attribute :rating, :type => DataType::Integer #cost of the perk chosen
	# 	# attribute :description #what does it mean?
	# 	# reference :character, "AresMUSH::Character"

	# 	if charicf #has there an ICF selected?
	# 		cifstring = Hash.new
	# 		tempcifstring = []

	# 		charcgicf = swrifts_iconicf.select { |ss| ss['name'].downcase == charicf.downcase }.first
	# 		# get the entry in global file that matches the ICF name selected. We're going to make this pretty.
	# 		pattern = 'hj'
	# 		charhjicf = charcgicf.select{ |k,v| k[pattern] }
	# 		if (charhjicf.length > 0)
	# 			charhjicf.each do |k,v|
	# 				tempcifstring = []
	# 				hjopt = k.split("_")[0]
    #       			hjname = hjopt.gsub("hj","")
	# 				v.each do |k1,v1|
	# 					tempcifstring << {table: k1, name: hjopt, tablename: hjname}
	# 				end
	# 				cifstring[hjopt] = tempcifstring
	# 			end
	# 		end
	# 	end
	# 	return (cifstring);
	# end	


  ####### This is probably not needed - I still have to calculate the points dynamically ####
	def self.acl_returncgpoints(cg) #cg is swrifts_chargenpoints, the points set on the character object.
		txtstring = []
		cg.to_a.sort_by { |a| a.name }
			.each_with_index
				.map do |a, i|
					txtstring << {name: a.name, rating: a.rating}
			end
			return (txtstring)
	end

#########

	def self.save_abilities_for_chargen(char, chargen_data)

		if (!chargen_data[:custom])
			return ["No Custom Data"]
		end

		init = Global.read_config('swrifts', 'init')
		dbgstr = ''

		#Get the iconic framework and race set on the form
		if (chargen_data[:custom][:iconicf])
			c_iconicf = chargen_data[:custom][:iconicf][:class]
			icf_downcase = c_iconicf.downcase.strip  # Stripped and downcased iconicframework name.
		else
			icf_downcase = ''
		end

		# if (chargen_data[:custom][:race] && chargen_data[:custom][:race][:class] != 'None')
		if (chargen_data[:custom][:race])
			c_race = chargen_data[:custom][:race][:class]
			race_downcase = c_race.downcase.strip  # Stripped and downcased race name.
		else
			race_downcase = ''
		end
		c_edges = chargen_data[:custom][:cgedges]
		c_edgesnofw = chargen_data[:custom][:cgedgesnofw]
		c_edgesfw = chargen_data[:custom][:cgedgesfw]
		c_hind = chargen_data[:custom][:cghind]
		c_hindnofw = chargen_data[:custom][:cghindnofw]
		c_hindfw = chargen_data[:custom][:cghindfw]
        c_charhindpoints = chargen_data[:custom][:charhindpoints]
		#c_charperkpoints = chargen_data[:custom][:charperkpoints]
		c_hj = chargen_data[:custom][:hjtables]


		## ----- Update Iconic Framework

			char.delete_swrifts_chargen #clear out the character
			tt = Swrifts.run_init(char, init)  #Calls run_init in helpers.rb

			# If an Iconic Framework has been chosen
			if (icf_downcase)
				#Set the iconic framework
				iconicf = Global.read_config('swrifts', 'iconicf') #Read the config file for Iconic Frameworks
				icfsel = iconicf.select { |ss| ss['name'].downcase == icf_downcase }.first #Filter the icf's to find the one that's been selected

				tt1 = Swrifts.run_system(char, icfsel) #Set the base stats based on the ICF chosen.
				trait = Swrifts.find_traits(char, 'iconicf')   #Calls find_traits in helpers.rb
				trait.update(rating: icf_downcase)  #Update the Icf with the one chosen.
			end

			if (race_downcase)
				race = Swrifts.find_race_config(race_downcase) #get the Race entry we're working with from the yml
				if (!icf_downcase)
					tt3 = Swrifts.run_system(char, race)
				end
				#Set the Race
				race_trait = Swrifts.find_traits(char, 'race')	 #get the Race trait off of the character
				race_trait.update(rating: race_downcase) #Update the race with the one chosen.
			end

			#Save the no framework edges
			if (c_edgesnofw)  #If there are edges not related to the Iconic Framework and Race
				c_edgesnofw.each do |key,value|  #Cycle through each one
					edge_name = "#{value['name']}" #set the name to all lowercase
					ss = Swrifts.add_feature(char, SwriftsEdges, "edges", edge_name) #Call the add_feature function helpers.rb
					dbgstr << "Edge name: #{edge_name}, SS: #{ss}"  #For troubleshooting.
          			#dbgstr << "Edge name: #{edge_name}"
				end
			end

			# Save the no framework hinderance

			if (c_hindnofw) #If there are hinderances not related to the Iconic Framework and Race
         		# dbgstr << "Hind: #{c_hindnofw.inspect}"
  				c_hindnofw.each do |key, value| #Cycle through each one
  					edge_name = "#{value['name']}" #set the name to all lowercase
  					ss = Swrifts.add_feature(char, SwriftsHinderances, "hinderances", edge_name) #Call the add_feature function helpers.rb
  					dbgstr << "Hind name: #{edge_name}, #{ss}" #For troubleshooting
  				end
			end

			if (c_charhindpoints) #Is there perk points on the character?
				char.update(swrifts_perkpoints: c_charhindpoints )
				#dchar.update(swrifts_charhindpoints: c_charhindpoints )				
				dbgstr << " Perks: #{c_charhindpoints}"
			end

			#if (c_charperkpoints) #If there are heroes journey tables, save them.
			#	c_charperkpoints.each do |key, value| #cycle through each one
			#		element_name = "#{value['name']}" #Raise An Attribute
			#		element_table = "#{value['cost']}" #cost
			#		if (element_table) != 'None'
			#			element_desc = Swrifts.hj_desc(char, element_name, element_table)
			#			hj_element = char.swrifts_heroesj.select { |a| a.name.downcase == element_name }.first
			#			hj_element.update(table: element_table)
			#			hj_element.update(description: element_desc)
			#			dbgstr << "Charperkpoints: #{element_name}, #{element_table}, #{element_desc}"
			#		end
			#	end
			#end
			
			if (c_hj) #If there are heroes journey tables, save them.
				c_hj.each do |key, value| #cycle through each one
					element_name = "#{value['name']}" #hj1
					element_table = "#{value['table']}" #Body Armor
					if (element_table) != 'None'
						element_desc = Swrifts.hj_desc(char, element_name, element_table)
						hj_element = char.swrifts_heroesj.select { |a| a.name.downcase == element_name }.first
						hj_element.update(table: element_table)
						hj_element.update(description: element_desc)
						dbgstr << "HJ: #{element_name}, #{element_table}, #{element_desc}"
					end

				end
			end
			return (dbgstr)
	end #save
  end #end Swrifts
end
