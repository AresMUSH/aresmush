module AresMUSH
  bootstrapper = AresMUSH::Bootstrapper.new
  
  puts "======================================================================="
  puts "Make channel aliases into an array."
  puts "======================================================================="
  
  Character.all.each do |c|
    c.channel_options.each do |k, chan|
      if (!chan["alias"].kind_of?(Array))
        chan["alias"] = [ chan["alias"] ]
      end
    end
    c.save!
  end
  
  puts "Upgrade complete!"
end