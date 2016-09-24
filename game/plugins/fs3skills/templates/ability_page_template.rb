module AresMUSH
  module FS3Skills
    class AbilityPageTemplate < ErbTemplateRenderer

      include TemplateFormatters

      attr_accessor :data
      
      def initialize(file, data)
        @data = data
        super File.dirname(__FILE__) + file
      end
    end
  end
end