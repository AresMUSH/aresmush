module AresMUSH
  module Describe
    class ExitTemplate
      include TemplateFormatters
      
      def initialize(model)
        @model = model
      end
      
      def name
        @model.name
      end
      
      def description
        @model.description
      end
      
      def destination
        @model.dest.nil? ? t('describe.nowhere') : @model.dest.name
      end
    end
  end
end
