module AresMUSH
  class Character < Ohm::Model
#----- These are in aresmush\game\config and are the YML files
    collection :swade_stats, "AresMUSH::SwadeStats"
	collection :swade_skills, "AresMUSH::SwadeSkills"
#	collection :swade_hinderances, "AresMUSH::SwadeHinderances"
#	collection :swade_edges, "AresMUSH::SwadeEdges"
#	collection :swade_powers, "AresMUSH::SwadePowers"

	attribute :swade_iconicf
	attribute :swade_ppe_max
	attribute :swade_isp_max
	
	before_delete :delete_swade_chargen
    
    def delete_swade_chargen
      [ self.swade_stats ].each do |list|
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
	
  
    # class SwadeSkills < Ohm::Model
		# include ObjectModel
    
		# attribute :name
		# attribute :die_step
		# reference :character, "AresMUSH::Character"
		# index :name
	# end

	# class SwadeHinderances < Ohm::Model
		# include ObjectModel
    
		# attribute :name
		# reference :character, "AresMUSH::Character"
		# index :name
	# end
  
end