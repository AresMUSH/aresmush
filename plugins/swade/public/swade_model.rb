module AresMUSH
	class Character < Ohm::Model
#----- These are in aresmush\game\config and are the YML files
		collection :swade_stats, "AresMUSH::SwadeStats"
		collection :swade_skills, "AresMUSH::SwadeSkills"
		collection :swade_hinderances, "AresMUSH::SwadeHinderances"
		collection :swade_edges, "AresMUSH::SwadeEdges" 
		collection :swade_mpowers, "AresMUSH::SwadeMpowers"
		collection :swade_ppowers, "AresMUSH::SwadePpowers"
		collection :swade_cybernetics, "AresMUSH::SwadeCybernetics"
		collection :swade_chargenpoints, "AresMUSH::SwadeChargenpoints"
		collection :swade_abilities, "AresMUSH::SwadeAbilities"
		collection :swade_complications, "AresMUSH::SwadeComplications"

		attribute :swade_iconicf
		attribute :swade_ppe_max
		attribute :swade_isp_max
		
		before_delete :delete_swade_chargen
		
		def delete_swade_chargen
		  [ self.swade_stats, self.swade_skills, self.swade_hinderances, self.swade_edges, self.swade_abilities, self.swade_complications, self.swade_chargenpoints, self.swade_cybernetics ].each do |list|
				list.each do |a|
					a.delete
					end
				end
			end
		end

		class SwadeStats < Ohm::Model
			include ObjectModel
		
			attribute :name
			attribute :rating, :type => DataType::Integer
			reference :character, "AresMUSH::Character"
			index :name
		end	
		
	  
		class SwadeSkills < Ohm::Model
			include ObjectModel
		
			attribute :name
			attribute :rating
			reference :character, "AresMUSH::Character"
			index :name
		end


		class SwadeHinderances < Ohm::Model
			include ObjectModel
		
			attribute :name
			reference :character, "AresMUSH::Character"
			index :name
		end
		
		
		class SwadeEdges < Ohm::Model
			include ObjectModel
		
			attribute :name
			reference :character, "AresMUSH::Character"
			index :name
		end
		
			class SwadeMpowers < Ohm::Model
			include ObjectModel
		
			attribute :name
			reference :character, "AresMUSH::Character"
			index :name
		end

		
			class SwadePpowers < Ohm::Model
			include ObjectModel
		
			attribute :name
			reference :character, "AresMUSH::Character"
			index :name
		end

		
		class SwadeCybernetics < Ohm::Model
			include ObjectModel
		
			attribute :name
			reference :character, "AresMUSH::Character"
			index :name
		end
		
		class SwadeChargenpoints < Ohm::Model
			include ObjectModel
		
			attribute :name
			attribute :points
			reference :character, "AresMUSH::Character"
			index :name
		end
		
		class SwadeAbilities < Ohm::Model
			include ObjectModel
		
			attribute :name
			reference :character, "AresMUSH::Character"
			index :name
		end
		
		class SwadeComplications < Ohm::Model
			include ObjectModel
		
			attribute :name
			reference :character, "AresMUSH::Character"
			index :name
		end
		
	end
end