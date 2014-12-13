module AresMUSH
  module Api
    class GameCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'games'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("game")
      end
      
      def crack!
        self.name = cmd.args
      end
      
      def handle
        game = ServerInfo.all.select { |g| g.name.upcase == self.name.upcase }.first
        if (game.nil?)
          client.emit_failure t('api.game_not_found')
          return
        end
        
        text = t('api.game_name', :name => game.name)
        if (!game.is_open?)
          text << "%R%xh%xr" 
          text << t("api.game_not_open")
        end
        
        text << "%R"
        text << t('api.game_address', :host => game.host, :port => game.port)
        text << "%R"
        text << t('api.game_category', :category => game.category)
        text << "%R"

        last_ping = OOCTime.local_long_timestr(client, game.last_ping)        
        if (Time.now - game.last_ping < 86400)
          status = t('api.game_up_status')
        else
          status = t('api.game_down_status')
        end
        
        text << t('api.game_status', :status => status, :last => last_ping)
        text << "%r%r"
        text << game.description
        
        client.emit BorderedDisplay.text text, t('api.games_title')
      end
    end
  end
end
