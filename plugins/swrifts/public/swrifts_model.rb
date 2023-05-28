module AresMUSH
	class Character < Ohm::Model
#----- These are in aresmush\game\config and are the YML files
		collection :swrifts_traits, "AresMUSH::SwriftsTraits"
		collection :swrifts_counters, "AresMUSH::SwriftsCounters"
		collection :swrifts_stats, "AresMUSH::SwriftsStats"
		collection :swrifts_statsmax, "AresMUSH::SwriftsStatsmax"
		collection :swrifts_dstats, "AresMUSH::SwriftsDstats"
		collection :swrifts_chargenpoints, "AresMUSH::SwriftsChargenpoints"
		collection :swrifts_skills, "AresMUSH::SwriftsSkills"
		collection :swrifts_chargenmin, "AresMUSH::SwriftsChargenmin"
		collection :swrifts_advances, "AresMUSH::SwriftsAdvances"
		collection :swrifts_hinderances, "AresMUSH::SwriftsHinderances"
		collection :swrifts_edges, "AresMUSH::SwriftsEdges"
		collection :swrifts_mpowers, "AresMUSH::SwriftsMpowers"
		collection :swrifts_ppowers, "AresMUSH::SwriftsPpowers"
		collection :swrifts_cybernetics, "AresMUSH::SwriftsCybernetics"
		collection :swrifts_abilities, "AresMUSH::SwriftsAbilities"
		collection :swrifts_complications, "AresMUSH::SwriftsComplications"
		collection :swrifts_heroesj, "AresMUSH::SwriftsHeroesj"
		collection :swrifts_randnum, "AresMUSH::SwriftsRandnum"
		collection :swrifts_fandg, "AresMUSH::SwriftsFandg"
		collection :swrifts_charperks, "AresMUSH::SwriftsCharPerks"

		attribute :swrifts_iconicf
		attribute :swrifts_race

		before_delete :delete_swrifts_chargen

		def delete_swrifts_chargen
			[ self.swrifts_stats, self.swrifts_skills, self.swrifts_hinderances, self.swrifts_edges, self.swrifts_abilities, self.swrifts_chargenpoints, self.swrifts_complications, self.swrifts_cybernetics, self.swrifts_mpowers, self.swrifts_ppowers, self.swrifts_counters, self.swrifts_traits, self.swrifts_dstats, self.swrifts_statsmax, self.swrifts_chargenmin, self.swrifts_advances, self.swrifts_heroesj].each do |list|
				list.each do |a|
					a.delete
				end
			end
		end
	end

 	class SwriftsTraits < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating
		reference :character, "AresMUSH::Character"
		index :name
	end

  	class SwriftsCounters < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsStats < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsStatsmax < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsDstats < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsChargenpoints < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsSkills < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsChargenmin < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsHeroesj < Ohm::Model
		include ObjectModel

		attribute :name #hj1, hj2, etc.
		attribute :rating, :type => DataType::Integer #the random roll
		attribute :table #Body Armor, etc.
		attribute :description #text from table
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsFandg < Ohm::Model
		include ObjectModel

		attribute :name #fandg1, fandg2, etc.
		attribute :rating, :type => DataType::Integer #the random roll
		attribute :description #text from roll
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsAdvances < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsHinderances < Ohm::Model
		include ObjectModel

		attribute :name
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsEdges < Ohm::Model
		include ObjectModel

		attribute :name
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsMpowers < Ohm::Model
		include ObjectModel

		attribute :name
		reference :character, "AresMUSH::Character"
		index :name
	end


	class SwriftsPpowers < Ohm::Model
		include ObjectModel

		attribute :name
		reference :character, "AresMUSH::Character"
		index :name
	end


	class SwriftsCybernetics < Ohm::Model
		include ObjectModel

		attribute :name
		reference :character, "AresMUSH::Character"
		index :name
	end


	class SwriftsAbilities < Ohm::Model
		include ObjectModel

		attribute :name
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsComplications < Ohm::Model
		include ObjectModel

		attribute :name

		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsRandnum < Ohm::Model
		include ObjectModel

		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end

	class SwriftsCharPerks < Ohm::Model
		include ObjectModel
		attribute :name #Raise An Edge etc.
		attribute :cost, :type => DataType::Integer #how many perk points it is
		attribute :description #What is in 
		reference :character, "AresMUSH::Character"		
		index :name
	end	


end
