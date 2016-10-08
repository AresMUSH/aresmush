module AresMUSH
  module Describe
    class OutfitViewCmd
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
        
        client.emit BorderedDisplay.text(outfit.description, t('describe.outfit', :name => self.name))
      end
    end    
  end
end
