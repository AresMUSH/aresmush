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
        self.name = titleize_input(cmd.args)
      end
      
      def check_outfit_exists
        return t('describe.outfit_does_not_exist', :name => self.name) if client.char.outfit(self.name).nil?
        return nil
      end
      
      def handle
        outfit = client.char.outfit(self.name)
        client.emit BorderedDisplay.text(outfit, t('describe.outfit', :name => self.name))
      end
    end    
  end
end
