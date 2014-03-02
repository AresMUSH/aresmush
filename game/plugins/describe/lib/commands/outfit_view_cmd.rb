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
        return t('describe.outfit_does_not_exist', :name => self.name) if !client.char.outfits.has_key?(self.name)
        return nil
      end
      
      def handle
        output = "%l1"
        output << "%r%xh" << t('describe.outfit', :name => self.name) << "%xn"
        output << "%r" << client.char.outfits[self.name]
        output << "%r%l1"
        client.emit output
      end
    end    
  end
end
