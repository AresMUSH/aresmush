module AresMUSH

  module FS3Skills
    class RaiseAbilityCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include PluginWithoutSwitches
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("raise") || cmd.root_is?("lower")
      end

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        current_rating = FS3Skills.ability_rating(client.char, self.name)
        mod = cmd.root_is?("raise") ? 1 : -1
        FS3Skills.set_ability(client, client.char, self.name, current_rating + mod)
        client.char.save
      end
    end
  end
end
