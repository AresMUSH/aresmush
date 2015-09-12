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
        
        template = GamesListTemplate.new games, self.page, client
        template.render
      end
    end
  end
end
