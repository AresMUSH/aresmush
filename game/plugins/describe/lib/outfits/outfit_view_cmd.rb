module AresMUSH
  module Describe
    class OutfitViewCmd
      include CommandHandler
           
      attr_accessor :name
      
      def help
        "`outfits` - Lists outfits\n" + 
        "`outfit <name>` - Views an outfit."
      end
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def handle
        outfit = enactor.outfit(self.name)
        if (!outfit)
          client.emit_failure t('describe.outfit_does_not_exist', :name => self.name)
          return
        end
        
        template = BorderedDisplayTemplate.new outfit.description, t('describe.outfit', :name => self.name)
        client.emit template.render
      end
    end    
  end
end
