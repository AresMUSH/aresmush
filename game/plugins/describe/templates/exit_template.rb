module AresMUSH
  module Describe
    # Template for an exit.
    class ExitTemplate
      include TemplateFormatters
      
      def initialize(model, client)
        @model = model
      end
      
      def display
        text = "%l1%r"
        text << "%xg[#{name}] #{destination}%xn%r"
        text << "#{description}%r"
        text << "%l1"
        
        text
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
