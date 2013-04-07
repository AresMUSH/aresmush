module AresMUSH
  module Who
    class WhoFooter < TemplateRenderer
      def initialize(clients, container)
        @clients = clients
        @config_reader = container.config_reader
      end

      def template
        @config_reader.config["who"]["footer"]
      end

      def online_total
        @clients.count
      end

      def ic_total
        ic_people = @clients.select { |client| Who.is_ic?(client.char) }
        ic_people.count
      end
    end

  end
end