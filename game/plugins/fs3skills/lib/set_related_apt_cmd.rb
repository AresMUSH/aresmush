module AresMUSH

  module FS3Skills
    class SetRelatedAptCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include PluginWithoutSwitches
      
      attr_accessor :name, :related_apt

      def initialize
        self.required_args = ['name', 'related_apt']
        self.help_topic = 'abilities'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("relatedapt")
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.related_apt = titleize_input(cmd.args.arg2)
      end

      def check_valid_ability
        return nil if client.char.fs3_interests.include?(self.name)
        return nil if client.char.fs3_expertise.include?(self.name)
        return t('fs3skills.invalid_ability_for_related_apt', :ability => self.name)
      end
      
      def check_valid_attr
        return t('fs3skills.invalid_aptitude', :name => self.related_apt) if !FS3Skills.aptitude_names.include?(self.related_apt)
        return nil
      end
        
      def handle
        client.char.fs3_related_apts[self.name] = self.related_apt
        client.char.save
        client.emit_success t('fs3skills.related_apt_set', :ability => self.name, :related_apt => self.related_apt)
      end
    end
  end
end
