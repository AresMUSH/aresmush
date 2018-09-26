# module AresMUSH
  # module Custom
    # class CronEventHandler
      # def on_event(event)
        # config = Global.read_config("potions", "potion_update_cron")
        # return if !Cron.is_cron_match?(config, event.time)
        
        # Character.all.each do |c|
          # Custom.update_potion_hours(c) 
        # end
        
        # char = Character.find_one_by_name("Nessie")
        # Rooms.emit_to_room(char.room , "This fucking works.")
        
          
      # end
    # end
  # end
# end