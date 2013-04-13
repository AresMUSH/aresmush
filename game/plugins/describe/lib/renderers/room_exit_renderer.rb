module AresMUSH

  module Describe
    class RoomExitRenderer < TemplateRenderer
      def initialize(exit, container)
        @config_reader = container.config_reader
        @data = HashReader.new(exit)
      end

      def template
        @config_reader.config["desc"]["room"]["each_exit"]
      end
    end
  end
end