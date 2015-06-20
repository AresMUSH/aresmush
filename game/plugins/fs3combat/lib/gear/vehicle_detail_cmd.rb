module AresMUSH
  module FS3Combat
    class VehicleDetailCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'vehicles'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("vehicle")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_vehicle_exists
        return t('fs3combat.invalid_vehicle') if !FS3Combat.vehicle(self.name)
        return nil
      end
      
      def handle
        list = FS3Combat.vehicle(self.name).sort.map { |k, v| type_display(k, v) }
        client.emit BorderedDisplay.list list, self.name
      end
        
      def type_display(name, info)
        title = t("fs3combat.vehicle_title_#{name}")
        if (name == "hitloc_chart")
          hitloc = FS3Combat.hitloc(info)
          detail = FS3Combat.gear_detail(hitloc["default"].uniq)
        else
          detail = FS3Combat.gear_detail(info)
        end
        "%xh#{left(title, 20)}%xn #{detail}"
      end
    end
  end
end