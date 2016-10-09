module AresMUSH
  module Manage
    class FindsiteCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      
      attr_accessor :target

      def crack!
        self.target = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.target ],
          help: 'findsite'
        }
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        result = ClassTargetFinder.find(self.target, Character, enactor)
        title = t('manage.findsite_title', :search => self.target)
      
        if (result.found?)
          suspect = result.target
          login_status = suspect.login_status
          ip = login_status.last_ip
          hostname = login_status.last_hostname[0..10]
        else
          
            if (self.target[0].is_integer?)
              ip = self.target
              begin
                hostname = Resolv.getname self.target
              rescue
                client.emit_failure t('manage.findsite_failed_lookup', :target => self.target)
                hostname = ""
              end
            else
              hostname = self.target
              begin
                ip = Resolv.getaddress self.target
              rescue
                client.emit_failure t('manage.findsite_failed_lookup', :target => self.target)
                ip = ""
              end
            end
        end

        title = "#{title}%r#{t('manage.findsite_player_info', :ip => ip, :hostname => hostname)}"
        
        matches = Character.all.select { |c| Login::Api.is_site_match?(c, ip, hostname) }
        found = matches.map { |m| "#{m.name.ljust(25)} #{m.login_status.last_ip} #{m.login_status.last_hostname}" }
        
        client.emit BorderedDisplay.list found, title
      end
      
    end
  end
end
