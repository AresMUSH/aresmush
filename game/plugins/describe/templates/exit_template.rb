module AresMUSH
  module Describe
    # Template for an exit.
    class ExitTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(model, client)
        @model = model
        super client
      end
      
      def build
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
