module AresMUSH
  module Api
    class GamesListTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(games, page, client)
        @games = games
        @page = page
        super client
      end
      
      def build
        games = @games.select { |g| g.is_open? }
        games = games.sort_by {|g| [g.category.nil? ? "" : g.category, g.name] }
        list = games.map { |s| "#{left(s.name, 60)} #{left(s.category, 15)}" }

        if (!Global.api_router.is_master?)
          footer = t('api.full_games_list_at_central')
        else
          footer = ""
        end
        BorderedDisplay.paged_list list, @page, 15, t('api.games_title'), footer
      end
    end
  end
end