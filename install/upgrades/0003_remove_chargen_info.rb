module AresMUSH
  bootstrapper = AresMUSH::Bootstrapper.new
  AresMUSH::Global.plugin_manager.load_all
  
  # Fixes errors like undefined method `chargen_stage=' for #<AresMUSH::Character:0x007fcca57994f0>
  # resulting from deleting an attribute from the code when there's still data in the database.
  
  # First you have to re-define the fields you deleted.
  class Character
    attribute :cookie_count
    attribute :timezone
    attribute :autospace
  end
  
  class Room
    attribute :repose_on
    attribute :poses
  end
  
  puts "======================================================================="
  puts "Remove chargen fields."
  puts "======================================================================="
  
  # Then wipe out the field on all affected objects.
  Character.all.each do |c|
    c.cookie_count = nil
    c.timezone = nil
    c.autospace = nil
    c.save
  end
  
  Room.all.each do |r|
    r.repose_on = nil
    r.poses = nil
    r.save
  end
  
  puts "Upgrade complete!"
end