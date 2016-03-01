module AresMUSH
  module Rooms
    class FoyerCmd
      include CommandHandler
      include CommandRequiresLogin

      attr_accessor :option
      
      def want_command?(client, cmd)
        cmd.root_is?("foyer")
      end
            
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
        client.room.is_foyer = self.option.is_on?
        client.room.save
        if (self.option.is_on?)
          client.emit_ooc t('rooms.foyer_set')
        else
          client.emit_ooc t('rooms.foyer_cleared')
        end
      end
    end
  end
end
