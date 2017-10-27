module AresMUSH
  module Describe
    # Template for an exit.
    class ExitTemplate < ErbTemplateRenderer
      
      attr_accessor :ex
      
      def initialize(model)
        @ex = model
        super File.dirname(__FILE__) + "/exit.erb"        
      end
      
      def destination
        !@ex.dest ? t('describe.nowhere') : @ex.dest.name
      end
    end
  end
end
