module AresMUSH
  module Manage
    class BanCmd
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

      def check_admin
        return nil if enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          
          if (model.is_admin?)
            client.emit_failure t('manage.cant_ban_admins')
            return
          end
          
          host_and_ip = "IP: #{model.last_ip}  Host: #{model.last_hostname}"
          Global.logger.warn "#{model.name} banned by #{enactor_name}.  #{host_and_ip}"

          alts = AresCentral.alts(model)
          alts.each do |alt|
            if (!alt.is_admin?)
              Login.set_random_password(alt)
            end
          end
          if (model.handle)
            model.handle.delete
          end
           
          begin
            config = DatabaseMigrator.read_config_file("sites.yml")
            ban_list = (config['sites']['banned'] || [])
            ban_list << model.last_ip
            config['sites']['banned'] = ban_list.uniq
            DatabaseMigrator.write_config_file("sites.yml", config)          
            error = Manage.reload_config
          rescue Exception => ex
            error = ex
          end
          
          Login.boot_char(model, t('manage.you_have_been_banned'))
          
          message = t('manage.ban_message', :actor => enactor.name, :name => model.name, :reason => self.reason, :host => host_and_ip)
          job = Jobs.create_job(Jobs.trouble_category, 
            t('manage.ban_title'), 
            message, 
            Game.master.system_character)
            
          if (error)
            client.emit_failure t('manage.ban_config_error', :name => model.name, :error => error)
          else
            client.emit_success t('manage.player_banned', :name => model.name)
          end
        end
      end
    end
  end
end
