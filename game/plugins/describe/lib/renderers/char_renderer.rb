module AresMUSH

  module Describe
    class CharRenderer < TemplateRenderer
      def initialize(char, container)
        @config_reader = container.config_reader
        @data = HashReader.new(char)
      end

      def template
        @config_reader.config["desc"]["char"]
      end
    end
  end
end