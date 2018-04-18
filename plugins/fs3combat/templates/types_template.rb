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
      
      def use_vehicles
        Global.read_config("fs3combat", "allow_vehicles")
      end
    end
  end
end