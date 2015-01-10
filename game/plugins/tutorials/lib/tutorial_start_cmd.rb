module AresMUSH
  module Tutorials
    class TutorialStartCmd
      include Plugin
      include PluginRequiresArgs
      include PluginRequiresLogin

      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'tutorials'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("tutorial") && cmd.switch_is?("start")
      end
            
      def crack!
        self.name = cmd.args.nil? ? "" : trim_input(cmd.args).downcase
      end
      
      def check_valid_tutorial
        return t('tutorials.no_such_tutorial') if !Tutorials.is_valid_tutorial?(self.name)
        return nil
      end
        
      def handle
        client.char.tutorial = self.name
        client.char.tutorial_page_index = 0
        client.char.save!
        client.emit BorderedDisplay.text Tutorials.get_page(client.char)
      end
    end
  end
end
