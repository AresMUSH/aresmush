module AresMUSH
  module Describe
    class OutfitEditCmd
      include CommandHandler
      include CommandRequiresLogin
           
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        outfit = enactor.outfit(self.name)
        if (!outfit)
          client.emit_failure t('describe.outfit_does_not_exist', :name => self.name)
          return
        end
        
        Utils::Api.grab client, enactor, "outfit/set #{self.name}=#{outfit.description}"
      end
    end    
  end
end
