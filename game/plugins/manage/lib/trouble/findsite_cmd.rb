module AresMUSH
  module Manage
    class FindsiteCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      include PluginRequiresLogin
      
      attr_accessor :target
      
      def initialize
        self.required_args = ['target']
        self.help_topic = 'findsite'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("findsite")
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end

      def handle
        result = ClassTargetFinder.find(self.target, Character, client)
        title = t('manage.findsite_title', :search => self.target)
      
        if (result.found?)
          suspect = result.target
          ip = suspect.last_ip
          hostname = suspect.last_hostname[0..10]
        else
          if (self.target[0].is_integer?)
            ip = self.target
            hostname = Resolv.getname self.target
          else
            hostname = self.target
            ip = Resolv.getaddress self.target
          end
        end

        title = "#{title}%r#{t('manage.findsite_player_info', :ip => ip, :hostname => hostname)}"
        
        matches = Character.all.select { |c| c.is_site_match?(ip, hostname) }
        found = matches.map { |m| "#{m.name.ljust(25)} #{m.last_ip} #{m.last_hostname}" }
        
        client.emit BorderedDisplay.list found, title
      end
      
    end
  end
end
