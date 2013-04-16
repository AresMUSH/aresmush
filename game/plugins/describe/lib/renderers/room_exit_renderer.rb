module AresMUSH

  module Describe
    class RoomExitRenderer < TemplateRenderer
      def initialize(exit, container)
        @config_reader = container.config_reader
        @data = HashReader.new(exit)
      end

      def template
        @config_reader.config["desc"]["room"]["exits"]
      end
    end
  end
end