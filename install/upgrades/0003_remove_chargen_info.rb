module AresMUSH
  bootstrapper = AresMUSH::Bootstrapper.new
  AresMUSH::Global.plugin_manager.load_all
  
  # Fixes errors like undefined method `chargen_stage=' for #<AresMUSH::Character:0x007fcca57994f0>
  # resulting from deleting an attribute from the code when there's still data in the database.
  
  # First you have to re-define the fields you deleted.
  class Character
    attribute :edit_prefix
  end
  
  class Room
    attribute :grid_x
    attribute :grid_y
    attribute :area
    attribute :is_foyer
  end
  
  puts "======================================================================="
  puts "Remove chargen fields."
  puts "======================================================================="
  
  # Then wipe out the field on all affected objects.
  Character.all.each do |c|
    c.edit_prefix = nil
    c.save
  end
  
  Room.all.each do |r|
    r.grid_x = nil
    r.grid_y = nil
    r.area = nil
    r.is_foyer = nil
    r.save
  end
  
  puts "Upgrade complete!"
end