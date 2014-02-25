module AresMUSH
  module Describe
    class ExitData
      include ToLiquidHelper
      
      def initialize(model)
        @model = model
      end
      
      def name
        @model.name
      end
      
      def destination
        @model.destination.nil? ? t('describe.nowhere') : @model.destination.name
      end
    end
  end
end
