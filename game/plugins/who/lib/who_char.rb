module AresMUSH
  module Who
    class WhoChar < TemplateRenderer
      def initialize(client)
        @client = client        
        @data = HashReader.new(@client.char)
      end
      
      def template
        Global.config["who"]["each_char"]
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