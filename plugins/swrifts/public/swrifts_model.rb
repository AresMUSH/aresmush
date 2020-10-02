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


		attribute :swrifts_iconicf
		attribute :swrifts_race

		
		before_delete :delete_swrifts_chargen
		
		def delete_swrifts_chargen
			[ self.swrifts_stats, self.swrifts_skills, self.swrifts_hinderances, self.swrifts_edges, self.swrifts_abilities, self.swrifts_chargenpoints, self.swrifts_complications, self.swrifts_cybernetics, self.swrifts_mpowers, self.swrifts_ppowers, self.swrifts_counters, self.swrifts_traits ].each do |list|
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
	

end