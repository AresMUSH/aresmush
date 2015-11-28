module AresMUSH

  module FS3XP
    class XpAwardCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :xp

      def initialize
        self.required_args = ['name', 'xp']
        self.help_topic = 'xp'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("xp") && cmd.switch_is?("award")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.xp = trim_input(cmd.args.arg2)
      end
      
      def check_xp
        return nil if self.xp.nil?
        return t('fs3xp.invalid_xp_award') if !self.xp.is_integer?
        return nil
      end
      
      def check_can_award
        return nil if FS3XP.can_manage_xp?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          model.xp = model.xp + self.xp.to_i
          model.save
          Global.logger.info "#{self.xp} XP Awarded by #{client.name} to #{model.name}"
          client.emit_success t('fs3xp.xp_awarded', :name => model.name, :xp => self.xp)
        end
      end
    end
  end
end
