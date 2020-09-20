module AresMUSH
  class Character < Ohm::Model
#----- These are in aresmush\game\config and are the YML files
    collection :swade_attributes, "AresMUSH::SwadeAttributes"
#	collection :swade_skills, "AresMUSH::SwadeSkills"
#	collection :swade_hinderances, "AresMUSH::SwadeHinderances"
#	collection :swade_edges, "AresMUSH::SwadeEdges"
#	collection :swade_powers, "AresMUSH::SwadePowers"
#	collection :swade_iconicf, "AresMUSH::SwadeIconicf"

	attribute :swade_iconicf_name

#--- This is called in commands\reset_cmd.rb and public\cortex_model.rb     
#    before_delete :delete_cortex_abilities
#   
#    def delete_cortex_abilities
#      [ self.swade_attributes ].each do |list|
#        list.each do |a|
#          a.delete
#        end
#      end
#    end
	end
  
	class SwadeAttributes < Ohm::Model
		include ObjectModel
    
		attribute :name
		attribute :rating, :type => DataType::Integer
		reference :character, "AresMUSH::Character"
		index :name
	end	
	
	class SwadeIconicf < Ohm::Model
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