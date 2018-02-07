module AresMUSH
  
  puts "======================================================================="
  puts "Remove job number."
  puts "======================================================================="
  
  class Game
    attribute :next_job_number
  end
  
  class Job
    attribute :number
  end
  
  game = Game.master
  game.update(next_job_number: nil)
    
  Job.all.each { |j| j.update(number: nil) }    
  
  puts "Upgrade complete!"
end