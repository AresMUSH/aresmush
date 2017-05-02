module AresMUSH
  
  class Character
    reference :mail_prefs, "AresMUSH::MailPrefs"
  end
  
  class MailPrefs < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    
    attribute :copy_sent_mail, :type => DataType::Boolean
    attribute :mail_filter, :default => "Inbox"
  end
  
  
  puts "======================================================================="
  puts "Moves mail prefs onto the character itself."
  puts "======================================================================="

  MailPrefs.all.each do |c|
    c.character.update(copy_sent_mail: c.copy_sent_mail)
    c.character.update(mail_filter: c.mail_filter)
    c.delete
  end
  
  Character.all.each { |c| c.update(mail_prefs_id: nil) } 
  puts "Upgrade complete!"
end



