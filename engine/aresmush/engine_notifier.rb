module AresMUSH  
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
  class EngineNotifier
    
    def notify(type, msg, &trigger_block)
      Global.client_monitor.emit msg, &trigger_block
      
      formatted_msg = MushFormatter.format(msg)
      Global.client_monitor.notify_web_clients type, formatted_msg, false, &trigger_block
    end
    
    def notify_ooc(type, msg, &trigger_block)
      Global.client_monitor.emit_ooc msg, &trigger_block
      
      formatted_msg = MushFormatter.format(msg)      
      Global.client_monitor.notify_web_clients type, formatted_msg, false, &trigger_block
    end
  end
end
