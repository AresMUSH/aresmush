module AresMUSH
  
  class Character
    collection :bbs_read_marks, "AresMUSH::BbsReadMark"
  end
  
  
  
  class BbsReadMark < Ohm::Model
    include ObjectModel
    
    reference :bbs_post, "AresMUSH::BbsPost"
    reference :character, "AresMUSH::Character"
  end
  
  
  puts "======================================================================="
  puts "Removes bbs read marks."
  puts "======================================================================="

  BbsReadMark.all.each { |c| c.delete }
  puts "Upgrade complete!"
end



