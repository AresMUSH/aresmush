module AresMUSH
  module Login
    class BootCmd
      include CommandHandler
      
      attr_accessor :target, :reason
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
        self.target = trim_arg(args.arg1)
        self.reason = args.arg2
      end
      
      def required_args
        [ self.target, self.reason ]
      end

      def check_approved
        return nil if enactor.is_approved? || enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |bootee|
          
          if (bootee.is_admin? && !enactor.is_admin?)
            client.emit_failure t('login.cant_boot_admin')
            return
          end

          error = Login.boot_char(bootee, t('login.you_have_been_booted'))
          if (error)
            client.emit_failure error
            return
          end
          
          host_and_ip = "IP: #{bootee.last_ip}  Host: #{bootee.last_hostname}"
          Global.logger.warn "#{bootee.name} booted by #{enactor_name}.  #{host_and_ip}"
          
          job = Jobs.create_job(Jobs.trouble_category, 
            t('login.boot_title'), 
            t('login.boot_message', :booter => enactor.name, :bootee => bootee.name, :reason => self.reason), 
            enactor)
          Jobs.comment(job[:job], Game.master.system_character, host_and_ip, true)
          
        end
      end
    end
  end
end
