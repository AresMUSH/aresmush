module AresMUSH
  
  class Character
    collection :job_read_marks, "AresMUSH::JobReadMark"
  end
  
  class JobReadMark < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :job, "AresMUSH::Job"
  end
  
  
  puts "======================================================================="
  puts "Removes bbs read marks."
  puts "======================================================================="

  JobReadMark.all.each { |j| j.delete }
  puts "Upgrade complete!"
end



