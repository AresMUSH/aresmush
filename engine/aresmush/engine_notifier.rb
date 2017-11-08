module AresMUSH  
  class EngineNotifier
    
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
      Engine.client_monitor.emit_all msg, &trigger_block
      Engine.client_monitor.notify_web_clients type, msg, &trigger_block
    end
    
    def notify_ooc(type, msg, &trigger_block)
      Engine.client_monitor.emit_all_ooc msg, &trigger_block
      Engine.client_monitor.notify_web_clients type, msg, &trigger_block
    end
  end
end
