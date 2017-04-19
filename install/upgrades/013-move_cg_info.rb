module AresMUSH
  
  class Character
    reference :chargen_info, "AresMUSH::ChargenInfo"
  end
  
  
  class ChargenInfo < Ohm::Model
    include ObjectModel
    
    attribute :locked, :type => DataType::Boolean
    attribute :current_stage, :type => DataType::Integer
    reference :approval_job, "AresMUSH::Job"
    
    reference :character, "AresMUSH::Character"
  end
  
  puts "======================================================================="
  puts "Moves chargen info onto the character itself."
  puts "======================================================================="

  ChargenInfo.all.each do |c|
    c.character.update(chargen_locked: c.locked)
    c.character.update(chargen_stage: c.current_stage)
    c.character.update(approval_job: c.approval_job)
    c.delete
  end
  
  Character.all.each { |c| c.update(chargen_info_id: nil) } 
  puts "Upgrade complete!"
end



