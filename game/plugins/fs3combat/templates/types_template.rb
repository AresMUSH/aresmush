module AresMUSH
  module FS3Combat
    class CombatTypesTemplate < ErbTemplateRenderer

      include TemplateFormatters

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