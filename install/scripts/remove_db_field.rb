module AresMUSH
  
  puts "======================================================================="
  puts "Removing a database field."
  puts "======================================================================="

  # ************
  #    NOTE!    
  # ************
  # You have to modify this script with the appropriate field and database model.  This is just an example.

  # 1. Redefine the missing field temporarily in the model object.
  #class Character
  #  attribute :a_missing_field   # Always set it to a string attribute, even if it was an Int/Bool/Array before.
  #end

  # 2. Set the field to nil on all existing objects.
  #Character.all.each do |c|
  #  c.update(a_missing_field: nil)
  #end
  
  class Game
    attribute :m1_test
    attribute :m2_test
  end
  
  Game.master.update(m1_test: nil)
  Game.master.update(m2_test: nil)
  puts "Script complete!"
end