module AresMUSH

  module Describe
    class RoomHeaderRenderer < TemplateRenderer
      def initialize(room, container)
        @config_reader = container.config_reader
        @data = HashReader.new(room)
      end

      def template
        @config_reader.config["desc"]["room"]["header"]
      end
    end
  end
end