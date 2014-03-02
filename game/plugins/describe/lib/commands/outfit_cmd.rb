module AresMUSH

  module Describe
    class OutfitListCmd
      include AresMUSH::Plugin
           
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        (cmd.root_is?("outfit") || cmd.root_is?("outfits")) && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle
        output = "%l1" << "%r"
        output << "%xh" << t('describe.outfits') << "%xn"
        client.char.outfits.keys.each do |k|
          output << "%r" << k
        end
        output << "%r%l1"
        client.emit output
      end
      
    end
    
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
    
    class OutfitCreateCmd
      include AresMUSH::Plugin
      
      attr_accessor :name, :desc
      
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("outfit") && cmd.switch == "create"
      end
      
      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<desc>.+)/)
        self.name = cmd.args.name.normalize
        self.desc = cmd.args.desc
      end
      
      def handle
        client.char.outfits[self.name] = self.desc
        client.emit_success t('describe.outfit_created')
      end
    end
    
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
    
    class OutfitWearCmd
      include AresMUSH::Plugin
      
      attr_accessor :names
      
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("wear") || (cmd.root_is?("outfit") && cmd.switch == "wear")
      end
      
      def crack!
        self.names = nil if cmd.args.nil?
        self.names = cmd.args.split(' ').map { |n| n.normalize }
      end
      
      def validate_outfits_exist
        return t('describe.invalid_wear_syntax') if self.names.nil? || self.names.empty?
        self.names.each do |n|
          return t('describe.outfit_does_not_exist', :name => n) if !client.char.outfits.has_key?(n)
        end
        return nil
      end
      
      def handle
        client.char.description = ""
        self.names.each do |n|
          client.char.description << client.char.outfits[n]
        end
        client.emit_success t('describe.outfits_worn')
      end
    end
  end
end
