module AresMUSH

  module FS3Skills
    class RollCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :private_roll

      def initialize
        self.required_args = ['name']
        self.help_topic = 'roll'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("roll") && (cmd.switch.nil? || cmd.switch_is?("private"))
      end

      def crack!
        self.name = titleize_input(cmd.args)
        self.private_roll = cmd.switch_is?("private")
      end
      
      def handle
        die_result = FS3Skills.roll_ability(client.char, self.name)
        success_level = FS3Skills.get_success_level(die_result)
        success_title = FS3Skills.get_success_title(success_level)
        message = t('fs3skills.simple_roll_result', 
            :name => client.name,
            :roll => self.name,
            :dice => die_result.join(" "),
            :success => success_title
          )
        if (self.private_roll)
          client.emit message
        else
          client.room.emit message
        end
      end
    end
  end
end
