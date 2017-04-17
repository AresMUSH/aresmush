module AresMUSH
  
  class Character
    collection :profile_fields, "AresMUSH::ProfileField"
  end
  
  class ProfileField < Ohm::Model
    include ObjectModel
  
    attribute :name
    attribute :data
    reference :character, "AresMUSH::Character"
  
    index :name
  end
  
  puts "======================================================================="
  puts "Moves profile fields onto the character itself."
  puts "======================================================================="
  
  Character.all.each { |c| c.update(profile: {})}
  ProfileField.all.each do |p|
    profile = p.character.profile
    profile[p.name] = p.data
    p.character.update(profile: profile)
  end
  
  puts "Upgrade complete!"
end



