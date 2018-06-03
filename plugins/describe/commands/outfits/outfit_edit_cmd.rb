module AresMUSH
  module Describe
    class OutfitEditCmd
      include CommandHandler
           
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def handle
        outfit = enactor.outfit(self.name)
        if (!outfit)
          client.emit_failure t('describe.outfit_does_not_exist', :name => self.name)
          return
        end
        
        Utils.grab client, enactor, "outfit/set #{self.name}=#{outfit}"
      end
    end    
  end
end
