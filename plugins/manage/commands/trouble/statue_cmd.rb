module AresMUSH
  module Manage
    class StatueCmd
      include CommandHandler
      
      attr_accessor :target, :reason, :option
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
        self.target = trim_arg(args.arg1)
        self.reason = args.arg2
        self.option = cmd.root_is?("statue")
      end
      
      def required_args
        [ self.target, self.reason ]
      end

      def check_admin
        return nil if enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |statue|
          
          if (statue.is_admin?)
            client.emit_failure t('manage.cant_statue_admins')
            return
          end
          
          host_and_ip = "IP: #{statue.last_ip}  Host: #{statue.last_hostname}"

          if (self.option)
            statue_client = Login.find_game_client(statue)
            if (statue_client)           
              statue_client.emit_failure t('dispatcher.you_are_statue')
            end
                    
            Global.logger.warn "#{statue.name} turned to statue by #{enactor_name}.  #{host_and_ip}"
            message = t('manage.statue_message', :actor => enactor.name, :statue => statue.name, :reason => self.reason, :host => host_and_ip)
          else
            statue_client = Login.find_game_client(statue)
            if (statue_client)           
              boot_client.emit_failure t('manage.no_longer_statue')
            end
                    
            Global.logger.warn "#{statue.name} restored from statue by #{enactor_name}.  #{host_and_ip}"
            message = t('manage.unstatue_message', :actor => enactor.name, :name => statue.name, :reason => self.reason, :host => host_and_ip)
          end
          
          job = Jobs.create_job(Jobs.trouble_category, 
            t('manage.statue_title'), 
            message, 
            Game.master.system_character)
            
          statue.update(is_statue: self.option)
          Login.expire_web_login(statue)
        end
      end
    end
  end
end
