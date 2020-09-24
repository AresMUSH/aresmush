module AresMUSH
	class Character < Ohm::Model
#----- These are in aresmush\game\config and are the YML files
		collection :swrifts_stats, "AresMUSH::SwriftsStats"
		collection :swrifts_skills, "AresMUSH::SwriftsSkills"
		collection :swrifts_hinderances, "AresMUSH::SwriftsHinderances"
		collection :swrifts_edges, "AresMUSH::SwriftsEdges" 
		collection :swrifts_mpowers, "AresMUSH::SwriftsMpowers"
		collection :swrifts_ppowers, "AresMUSH::SwriftsPpowers"
		collection :swrifts_cybernetics, "AresMUSH::SwriftsCybernetics"
		collection :swrifts_chargenpoints, "AresMUSH::SwriftsChargenpoints"
		collection :swrifts_abilities, "AresMUSH::SwriftsAbilities"
		collection :swrifts_complications, "AresMUSH::SwriftsComplications"

		attribute :swrifts_iconicf
		attribute :swrifts_ppe_max
		attribute :swrifts_isp_max
		
		before_delete :delete_swrifts_chargen
		
		def delete_swrifts_chargen
			[ self.swrifts_stats, self.swrifts_skills, self.swrifts_hinderances, self.swrifts_edges, self.swrifts_abilities, self.swrifts_chargenpoints, self.swrifts_complications, self.swrifts_cybernetics, self.swrifts_mpowers, self.swrifts_ppowers ].each do |list|
				list.each do |a|
					a.delete
				end
			end
		end
	end
 
	class SwriftsStats < Ohm::Model
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

	class SwriftsChargenpoints < Ohm::Model
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