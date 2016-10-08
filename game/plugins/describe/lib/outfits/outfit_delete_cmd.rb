module AresMUSH
  module Describe
    class OutfitDeleteCmd
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
        
        outfit.delete
        client.emit_success t('describe.outfit_deleted')
      end
    end
  end
end
