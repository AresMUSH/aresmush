module AresMUSH
  
  puts "======================================================================="
  puts "Moving RP hooks to freeform text field."
  puts "======================================================================="
  
  class RpHook < Ohm::Model
    include ObjectModel

    index :name
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :description
  end  
  
  class Character
    collection :old_rp_hooks, "AresMUSH::RpHook"
  end
  
  Character.all.each do |c|
    new_hooks = c.old_rp_hooks.to_a.map { |h| "* **#{h.name}** - #{h.description}" }.join("%R")
    c.update(rp_hooks: new_hooks)
  end
  
  puts "Upgrade complete!"
end