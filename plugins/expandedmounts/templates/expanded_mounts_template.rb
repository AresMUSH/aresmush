module AresMUSH
  module ExpandedMounts
    class ExpandedMountsTemplate < ErbTemplateRenderer


      attr_accessor :title, :list
      
      def initialize
        super File.dirname(__FILE__) + "/expanded_mounts.erb"
      end
      
      def mounts
        Mount.all
      end
    end
  end
end 