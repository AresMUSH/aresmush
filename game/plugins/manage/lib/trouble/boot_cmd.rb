module AresMUSH
  module Manage
    class BootCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      
      attr_accessor :target
      
      def initialize
        self.required_args = ['target']
        self.help_topic = 'boot'
        super
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |bootee|
          boot_client = bootee.client
          if (boot_client.nil?)
            client.emit_failure t('manage.cant_boot_disconnected_player')
            return
          end
          
          boot_client.emit_failure t('manage.you_have_been_booted', :booter => client.char.name)
          boot_client.disconnect
          
          Global.logger.warn "#{bootee.name} booted by #{client}."
        end
      end
    end
  end
end
