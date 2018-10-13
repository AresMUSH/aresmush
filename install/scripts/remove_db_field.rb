module AresMUSH
  
  puts "======================================================================="
  puts "Removing a database field."
  puts "======================================================================="

  # ************
  #    NOTE!    
  # ************
  # You have to modify this script with the appropriate field and database model.  This is just an example.

  # 1. Redefine the missing field temporarily in the model object.
  # **IMPORTANT!** Always set it to a string attribute, even if it was an Int/Bool/Array before.
  #class Character
  #  attribute :a_missing_field   
  #end

  # 2. Set the field to nil on all existing objects.
  #Character.all.each do |c|
  #  c.update(a_missing_field: nil)
  #end

  puts "Script complete!"
end