module AresMUSH
  module Describe
    class OutfitDeleteCmd
      include CommandHandler
           
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def handle
        if (!enactor.has_outfit?(self.name))
          client.emit_failure t('describe.outfit_does_not_exist', :name => self.name)
          return
        end
        
        new_outfits = enactor.outfits
        new_outfits.delete(self.name)
        enactor.update(outfits: new_outfits)
        
        client.emit_success t('describe.outfit_deleted')
      end
    end
  end
end
