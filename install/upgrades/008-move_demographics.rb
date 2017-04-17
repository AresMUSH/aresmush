module AresMUSH
  
  puts "======================================================================="
  puts "Move demographics out of separate object"
  puts "======================================================================="
  
  class Character
    attribute :demographics_id
  end
  
  class DemographicInfo < Ohm::Model
    include ObjectModel
    
    attribute :gender, :default => "Other"
    attribute :birthdate, :type => DataType::Date

    attribute :height
    attribute :physique
    attribute :skin
    attribute :fullname
    attribute :hair
    attribute :eyes
    attribute :callsign
    attribute :actor
    
    reference :character, "AresMUSH::Character"
  end
  
  DemographicInfo.all.each do |d|
    d.character.update(birthdate: d.birthdate)
    d.character.update(demographics: {
      'height' => d.height,
      'physique' => d.physique,
      'skin' => d.skin,
      'hair' => d.hair,
      'eyes' => d.eyes,
      'callsign' => d.callsign,
      'gender' => d.gender,
      'actor' => d.actor,
      'fullname' => d.fullname
    })
    d.delete
    d.character.update(demographics_id: nil)
  end
  
  Character.all.each do |c|
    if (!c.demographics)
      c.update(demographics: {})
    end
  end
  
  puts "Upgrade complete!"
end