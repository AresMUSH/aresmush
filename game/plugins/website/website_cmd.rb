module AresMUSH
  module Website
    class WebsiteCmd
      include CommandHandler
            
      def handle
        port = Global.read_config("server", "webserver_port")
        host = Global.read_config("server", "hostname")
        wiki = Global.read_config("game", "website")
        url = "http://#{host}:#{port}"
        client.emit_ooc t('web.website_address', :portal => url, :wiki => wiki)
      end
    end
  end
end
