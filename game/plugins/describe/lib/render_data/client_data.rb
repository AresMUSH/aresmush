module AresMUSH
  module Describe
    class ClientData
      include TemplateFormatters
      
      def initialize(client)
        @client = client
        @char = client.char
      end
      
      def name
        @char.name
      end
      
      def description
        @char.description
      end
      
      def shortdesc
        @char.shortdesc
      end
    end
  end
end