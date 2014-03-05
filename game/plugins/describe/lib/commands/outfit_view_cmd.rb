module AresMUSH
  module Describe
    class OutfitViewCmd
      include AresMUSH::Plugin
           
      attr_accessor :name
      
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("outfit") && cmd.switch.nil? && !cmd.args.nil?
      end
      
      def crack!
        self.name = cmd.args.normalize
      end
      
      def validate_outfit_exists
        valid_outfit = !client.char.outfit(self.name).nil? || !Describe.outfit(self.name).nil?
        return t('describe.outfit_does_not_exist', :name => self.name) if !valid_outfit
        return nil
      end
      
      def handle
        outfit = client.char.outfit(self.name)
        client.emit BorderedDisplay.text(outfit, t('describe.outfit', :name => self.name))
      end
    end    
  end
end
