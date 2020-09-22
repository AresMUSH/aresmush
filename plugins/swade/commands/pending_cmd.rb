module AresMUSH    
  module Swade
    class PendingCmd
		include CommandHandler
  
		def handle
			client.emit_failure ("This command is still pending.")
		end
	  
    end
  end
end