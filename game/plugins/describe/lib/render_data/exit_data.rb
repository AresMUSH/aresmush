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
        @model.dest.nil? ? t('describe.nowhere') : @model.dest.name
      end
    end
  end
end
