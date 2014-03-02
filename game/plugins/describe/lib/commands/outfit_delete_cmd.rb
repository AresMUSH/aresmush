module AresMUSH
  module Describe
    class OutfitDeleteCmd
      include AresMUSH::Plugin
           
      attr_accessor :name
      
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("outfit") && cmd.switch == "delete"
      end
      
      def crack!
        self.name = cmd.args.normalize
      end
      
      def validate_outfit_exists
        return t('describe.outfit_does_not_exist', :name => self.name) if !client.char.outfits.has_key?(self.name)
        return nil
      end
      
      def handle
        client.char.outfits.delete(self.name)
        client.emit_success t('describe.outfit_deleted')
      end
    end
  end
end
