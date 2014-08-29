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
          title = "#{title}%r#{t('manage.findsite_player_info', :ip => ip, :hostname => hostname)}"
        else
          ip = self.target
          hostname = self.target
        end
        
        matches = Character.all.select { |c| is_match?(c, ip, hostname) }
        found = matches.map { |m| "#{m.name.ljust(25)} #{m.last_ip} #{m.last_hostname}" }
        
        client.emit BorderedDisplay.list found, title
      end
      
      def is_match?(char, ip, hostname)
        return true if char.last_ip.include?(ip[0..7])
        return true if char.last_hostname.include?(hostname[0..7].downcase)
        return false
      end
    end
  end
end
