module AresMUSH
  module Api
    class GamesCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      attr_accessor :filter, :page
      
      def want_command?(client, cmd)
        cmd.root_is?("game") && !cmd.switch
      end
      
      def crack!
        self.filter = cmd.args.nil? ? nil : cmd.args.upcase
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle          
        if (self.filter)
          games = ServerInfo.or({category_upcase: self.filter}, {name_upcase: self.filter})
        else
          games = ServerInfo.all
        end
        
        games = games.select { |g| g.is_open? }
        games = games.sort_by {|g| [g.category.nil? ? "" : g.category, g.name] }
        list = games.map { |s| "#{left(s.name, 60)} #{left(s.category, 15)}" }
        
        if (!Global.api_router.is_master?)
          footer = t('api.full_games_list_at_central')
        else
          footer = ""
        end
        client.emit BorderedDisplay.paged_list list, self.page, 15, t('api.games_title'), footer
      end
    end
  end
end
