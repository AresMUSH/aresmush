module AresMUSH

  module Describe
    class RoomContentRenderer < TemplateRenderer
      def initialize(char, container)
        @config_reader = container.config_reader
        @data = HashReader.new(char)
      end

      def template
        @config_reader.config["desc"]["room"]["contents"]
      end
    end
  end
end