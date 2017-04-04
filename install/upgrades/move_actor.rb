module AresMUSH
  
  puts "======================================================================="
  puts "Move actor to demographics instead of separate registry."
  puts "======================================================================="
  
  class Character
    reference :actor_registry, "AresMUSH::ActorRegistry"
  end
  
  class ActorRegistry < Ohm::Model
    include ObjectModel
     
     reference :character, "AresMUSH::Character"

     attribute :charname
     attribute :actor
  end
  
  ActorRegistry.all.each do |ar|
    ar.character.demographics.update(actor: ar.actor)
    ar.delete
  end
  
  Character.all.each { |c| c.update(actor_registry_id: nil) }
  
  puts "Upgrade complete!"
end