require 'mustache'

module AresMUSH
  module Who
    class WhoHeaderFormatter < Mustache
      def initialize(clients, container)
        @config_reader = container.config_reader
      end

      def format
        @config_reader.config["who"]["header_format"]
      end

      def render_default
        render(format)
      end

      def mush_name
        @config_reader.config["theme"]["mush_name"]
      end
    end
  end
end