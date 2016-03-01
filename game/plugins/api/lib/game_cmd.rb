module AresMUSH
  module Api
    class GameCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :name
           
      def want_command?(client, cmd)
        cmd.root_is?("game") && (cmd.args && !cmd.switch)
      end
      
      def crack!
        self.name = cmd.args
      end
      
      def handle
        games = ServerInfo.all.select { |g| g.name.upcase == self.name.upcase }
        
        if (games.empty?)
          client.emit_failure t('api.game_not_found')
          return
        end
        
        text = ""
        games.each { |g| show_game(g, text) }
        client.emit BorderedDisplay.text text, t('api.games_title')
      end
      
      def show_game(game, text)
        text << "%r%l2%r"
        

        text << t('api.game_name', :name => game.name)
        
        if (!game.is_open?)
          text << "%R%R%xh%xr"
          text << t("api.game_not_open")
          text << "%xn"
          return text
        end
        
        text << "%R"
        text << t('api.game_address', :host => game.host, :port => game.port)
        text << "%R"
        text << t('api.game_category', :category => game.category)
        text << "%R"
        text << t('api.game_website', :website => game.website)

        if (!game.is_master?)
          last_ping = OOCTime.local_long_timestr(client, game.last_ping)        
          if (Time.now - game.last_ping < 86400)
            status = t('api.game_up_status')
          else
            status = t('api.game_down_status')
          end
        
          text << "%R"
          text << t('api.game_status', :status => status, :last => last_ping)
        end
        
        text << "%r%r"
        text << game.description
        
        text
      end
    end
  end
end
