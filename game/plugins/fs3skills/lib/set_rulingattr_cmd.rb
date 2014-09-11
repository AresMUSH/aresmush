module AresMUSH

  module FS3Skills
    class SetRulingAttrCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include PluginWithoutSwitches
      
      attr_accessor :name, :ruling_attr

      def initialize
        self.required_args = ['name', 'ruling_attr']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("rulingattr")
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.ruling_attr = trim_input(cmd.args.arg2)
      end
      
      def check_valid_attr
        return nil if self.ruling_attr.nil?
        return t('fs3skills.invalid_attr') if !FS3Skills.attribute_names.include?(self.ruling_attr)
        return nil
      end
        
      def handle
        skills = FS3Skills.get_ability_hash(client.char, :background)
        if (!skills.has_key?(self.name))
          client.emit_failure t('fs3skills.no_such_bg_skill')
          return
        end
        
        skills[self.name]['ruling_attr'] = self.ruling_attr
        client.char.save
        client.emit_success t('fs3skills.ruling_attr_set', :ability => self.name, :ruling_attr => self.ruling_attr)
      end
    end
  end
end
