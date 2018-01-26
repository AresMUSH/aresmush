module AresMUSH
  module Manage
    class FindsiteCmd
      include CommandHandler
      
      attr_accessor :target

      def parse_args
        self.target = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.target ]
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
          ip = suspect.last_ip || ""
          hostname = suspect.last_hostname ? suspect.last_hostname[0..10] : ""
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
        
        matches = Character.all.select { |c| Login.is_site_match?(c.last_ip, c.last_hostname, ip, hostname) }
        found = matches.map { |m| "#{m.name.ljust(25)} #{m.last_ip} #{m.last_hostname}" }
        
        template = BorderedListTemplate.new found, title
        client.emit template.render
      end
      
    end
  end
end
