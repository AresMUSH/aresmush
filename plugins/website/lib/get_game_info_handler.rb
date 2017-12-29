module AresMUSH
  module Website
    class GetGameInfoRequestHandler
      def handle(request)
        {
          type: 'game',
          id: 1,
          name: Global.read_config('game', 'name'),
          host: Global.read_config('server', 'hostname'),
          port: Global.read_config('server', 'port'),
          website_tagline: Global.read_config('website', 'website_tagline'),
          website_welcome: WebHelpers.format_markdown_for_html(Global.read_config('website', 'website_welcome')),
          onlineCount: Global.client_monitor.logged_in.count,
          ictime: ICTime.ic_datestr(ICTime.ictime)
        } 
      end
    end
  end
end