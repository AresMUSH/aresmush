module AresMUSH

  module FS3Skills
    class SetAptitudeCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include PluginWithoutSwitches
      
      attr_accessor :great, :good, :poor

      def initialize
        self.required_args = ['great', 'good', 'poor']
        self.help_topic = 'abilities'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("aptitude")
      end

      def crack!
        cmd.crack_args!(/(?<great>.+)\/(?<good>.+)\/(?<poor>.+)/)
        self.great = titleize_input(cmd.args.great)
        self.good = titleize_input(cmd.args.good)
        self.poor = titleize_input(cmd.args.poor)
      end
      
      def check_aptitudes
        [self.great, self.good, self.poor].each do |a|
          return t('fs3skills.invalid_aptitude', :name => a) if !FS3Skills.aptitude_names.include?(a)
        end
        return nil
      end
      
      def check_chargen_locked
        return nil if FS3Skills.can_manage_abilities?(client.char)
        Chargen.check_chargen_locked(client.char)
      end
      
      def handle
        FS3Skills.aptitude_names.each do |a|
          # Nil for client to avoid spam.
          FS3Skills.set_ability(nil, client.char, a, 2)
        end
        FS3Skills.set_ability(nil, client.char, self.great, 4)
        FS3Skills.set_ability(nil, client.char, self.good, 3)
        FS3Skills.set_ability(nil, client.char, self.poor, 1)
        client.char.save
        
        client.emit_success t('fs3skills.aptitude_set', :great => self.great, :good => self.good, :poor => self.poor)
      end
    end
  end
end
