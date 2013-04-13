module AresMUSH

  module Describe
    class RoomFooterRenderer < TemplateRenderer
      def initialize(room, container)
        @config_reader = container.config_reader
        @data = HashReader.new(room)
      end

      def template
        @config_reader.config["desc"]["room"]["footer"]
      end
    end
  end
end