module AresMUSH
  module Manage
    class BootCmd
      include CommandHandler
      
      attr_accessor :target
      
      def crack!
        self.target = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.target ],
          help: 'boot'
        }
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |bootee|
          boot_client = bootee.client
          if (!boot_client)
            client.emit_failure t('manage.cant_boot_disconnected_player')
            return
          end
          
          boot_client.emit_failure t('manage.you_have_been_booted', :booter => enactor.name)
          boot_client.disconnect
          
          Global.logger.warn "#{bootee.name} booted by #{client}."
        end
      end
    end
  end
end
