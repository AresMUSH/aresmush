module AresMUSH  
  class WebNotifier
    
    # trigger_block is a block that tells whether a particular web client
    # should receive a notification based on their character.  
    # 
    # If you want everyone to receive the notice, pass a block that always
    # returns true.
    #     notify(type, msg) do |char|
    #        true
    #     end
    #
    # If you want to only notify clients that can do something, pass a block
    # that checks a method based on the character.
    #
    #    notify(type, msg) do |char|
    #        char.can_do_something?
    #    end
    
    def notify(type, msg, &trigger_block)
      send_notification(type, msg, false, &trigger_block)
    end
    
    def notify_ooc(type, msg, &trigger_block)
      send_notification(type, msg, true, &trigger_block)
    end
    
    def send_notification(type, msg, ooc, &trigger_block)
      port = Global.read_config("server", "engine_api_port")
      host = Global.read_config("server", "hostname")
      char_ids = Character.all.select { |c| yield c }.map { |c| c.id }
     
      args = { :type => type, :ooc => ooc, :chars => char_ids.join(','), :message => msg }
      rest = AresMUSH::RestConnector.new("http://#{host}:#{port}")    
      rest.post("/api/notify", args)  
    end
  end
end
