module AresMUSH
  
  # Fixes errors like undefined method `chargen_stage=' for #<AresMUSH::Character:0x007fcca57994f0>
  # resulting from deleting an attribute from the code when there's still data in the database.
  
  # First you have to re-define the fields you deleted.
  class Character
    attribute :traits
  end
  
  
  puts "======================================================================="
  puts "Remove chargen fields."
  puts "======================================================================="

  # Then wipe out the field on all affected objects.
  Character.all.each do |c|
    c.traits = nil
    c.save
  end
  
  puts "Upgrade complete!"
end