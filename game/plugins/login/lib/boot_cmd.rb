module AresMUSH
  module Login
    class BootCmd
      include CommandHandler
      
      attr_accessor :target
      
      def help
        "`boot <name>` - Forcibly disconnects a player."
      end
      
      def parse_args
        self.target = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.target ]
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |bootee|
          
          if (bootee.is_admin? && !enactor.is_admin?)
            client.emit_failure t('login.cant_boot_admin')
            return
          end
          
          boot_client = bootee.client
          if (!boot_client)
            client.emit_failure t('login.cant_boot_disconnected_player')
            return
          end
          
          boot_client.emit_failure t('login.you_have_been_booted', :booter => enactor.name)
          boot_client.disconnect
          
          Global.logger.warn "#{bootee.name} booted by #{enactor_name}.  IP: #{bootee.last_ip}  Host: #{bootee.last_hostname}"
          
          Jobs.create_job(Global.read_config("login", "trouble_category"), 
            t('login.boot_title'), 
            t('login.boot_message', :booter => enactor.name, :bootee => bootee.name), 
            enactor)
        end
      end
    end
  end
end
