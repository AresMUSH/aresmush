module AresMUSH

  module Describe
    class ExitRenderer < TemplateRenderer
      def initialize(exit, container)
        @config_reader = container.config_reader
        @data = HashReader.new(exit)
      end

      def template
        @config_reader.config["desc"]["exit"]
      end
    end
  end
end