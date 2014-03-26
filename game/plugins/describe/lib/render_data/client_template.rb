module AresMUSH
  module Describe
    class ClientTemplate
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
      
      def fullname
        # TODO @char.fullname
        "Full Name"
      end
      
      def actor
        # TODO @char.actor
        "Cool Actor"
      end
    end
  end
end