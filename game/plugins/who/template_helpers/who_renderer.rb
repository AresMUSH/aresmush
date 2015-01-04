module AresMUSH
  module Who
    class WhoRenderer
      def initialize(filename)
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/#{filename}")
      end
      
      def render
        logged_in = Global.client_monitor.logged_in_clients
        clients = logged_in.map { |c| WhoClientTemplate.new(c) }
        data = WhoTemplate.new(clients)
        @renderer.render(data)
      end
    end
  end
end