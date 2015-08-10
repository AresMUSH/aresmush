module AresMUSH

  module FS3Skills
    class AddHookCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :desc

      def initialize
        self.required_args = ['name', 'desc']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("hook") && cmd.switch_is?("add")
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)        
        self.name = titleize_input(cmd.args.arg1)
        self.desc = cmd.args.arg2
      end
      
      def check_chargen_locked
        Chargen.check_chargen_locked(client.char)
      end
            
      def handle
        client.char.fs3_hooks[self.name] = self.desc
        client.char.save
        client.emit_success t('fs3skills.hook_selected', :name => self.name, :desc => self.desc)
      end
    end
  end
end
