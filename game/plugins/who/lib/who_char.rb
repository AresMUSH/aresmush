module AresMUSH
  module Who
    class WhoChar < TemplateRenderer
      def initialize(client, container)
        @client = client        
        @config_reader = container.config_reader
        @data = HashReader.new(@client.char)
      end
      
      def template
        @config_reader.config["who"]["each_char"]
      end

      def name
        @client.name
      end
      
      def idle
        @client.idle
      end   
    end
  end
end