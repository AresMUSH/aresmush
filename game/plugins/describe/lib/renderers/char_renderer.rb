module AresMUSH
  module Describe
    class CharRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/character.erb")
      end
      
      def render(model)
        client = Global.client_monitor.find_client(model)
        if (client.nil?)
          return t('db.object_not_found')
        end
        data = ClientData.new(client)
        @renderer.render(data)
      end
    end
  end
end