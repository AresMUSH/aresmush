module AresMUSH
  module FS3Combat
    class CombatTypesTemplate < ErbTemplateRenderer


      attr_accessor :list
      
      def initialize(list)
        @list = list.sort
        super File.dirname(__FILE__) + "/types.erb"
      end
      
      def field(info, name)
        info[name] || "---"
      end
    end
  end
end