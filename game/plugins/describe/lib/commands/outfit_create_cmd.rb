module AresMUSH

  module Describe
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
        client.char.save!
        client.emit_success t('describe.outfit_created')
      end
    end
  end
end
