module AresMUSH
  
  puts "======================================================================="
  puts "Protect BBS from trolls by adding approved role."
  puts "======================================================================="
  
  approved_role = Role.find_one(name: "approved")
  if (!approved_role)
    approved_role = Role.create(name: "approved")
  end
  
  Character.all.each do |c|
    if (c.is_approved?)
      c.roles.add approved_role
    end
  end
  
  BbsBoard.all.each do |b|
    roles = b.write_roles.to_a
    if (roles.empty?)
      b.write_roles.add approved_role
    end
  end
      
  puts "Upgrade complete!"
end