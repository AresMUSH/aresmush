module AresMUSH
  module Describe
    class OutfitDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
           
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_outfit_exists
        return t('describe.outfit_does_not_exist', :name => self.name) if client.char.outfit(self.name).nil?
        return nil
      end
      
      def handle
        client.char.outfits.delete(self.name)
        client.char.save
        client.emit_success t('describe.outfit_deleted')
      end
    end
  end
end
