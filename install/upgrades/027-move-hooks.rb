module AresMUSH
  
  puts "======================================================================="
  puts "Moving RP hooks to chargen module."
  puts "======================================================================="
  
  class FS3RpHook < Ohm::Model
    include ObjectModel

    index :name
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :description
  end  
  
  class Character
    collection :fs3_hooks, "AresMUSH::FS3RpHook"
  end
  
  Character.all.each do |c|
    FS3RpHook.all.each do |h|
      RpHook.create(character: h.character, name: h.name, description: h.description)
      h.delete
    end
  end
  
  puts "Upgrade complete!"
end