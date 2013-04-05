require 'mustache'

module AresMUSH
  module Who
    class WhoFooterFormatter < Mustache
      def initialize(clients, container)
        @clients = clients
        @config_reader = container.config_reader
      end

      def format
        @config_reader.config["who"]["footer_format"]
      end

      def render_default
        render(format)
      end

      def online_total
        @clients.count
      end

      def ic_total
        ic_people = @clients.select { |client| AresMUSH::Who.is_ic?(client.char) }
        ic_people.count
      end
    end

  end
end