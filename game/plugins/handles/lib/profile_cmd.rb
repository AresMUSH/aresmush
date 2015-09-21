module AresMUSH
  module Handles
    class ProfileCmd
      include Plugin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'profile'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("profile") && cmd.switch.nil?
      end
      
      def crack!
        self.name = cmd.args.nil? ? client.char.name : titleize_input(cmd.args)
      end
      
      def handle
        if (Handles.handle_name_valid?(name))
          Handles.get_profile(client, name)
        else
          ClassTargetFinder.with_a_character(name, client) do |model|
            template = CharProfileTemplate.new(client, model)
            template.render
          end
        end
      end      
    end

  end
end
