module AresMUSH

  module Describe
    class OutfitSetCmd
      include AresMUSH::Plugin
      
      attr_accessor :name, :desc
      
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("outfit") && cmd.switch_is?("set")
      end
      
      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<desc>.+)/)
        self.name = titleize_input(cmd.args.name)
        self.desc = cmd.args.desc
      end
      
      def validate_args
        return t('dispatcher.invalid_syntax', :command => 'outfit') if self.name.nil? || self.desc.nil?
        return nil
      end
      
      def handle
        client.char.outfits[self.name] = self.desc
        client.char.save!
        client.emit_success t('describe.outfit_set')
      end
    end
  end
end
