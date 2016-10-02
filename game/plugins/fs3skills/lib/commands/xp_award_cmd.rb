module AresMUSH

  module FS3Skills
    class XpAwardCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :xp

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.xp = trim_input(cmd.args.arg2)
      end

      def required_args
        {
          args: [ self.name, self.xp ],
          help: 'xp'
        }
      end
      
      def check_xp
        return nil if !self.xp
        return t('fs3skills.invalid_xp_award') if !self.xp.is_integer?
        return nil
      end
      
      def check_can_award
        return nil if FS3Skills.can_manage_xp?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          model.xp = model.xp + self.xp.to_i
          model.save
          Global.logger.info "#{self.xp} XP Awarded by #{enactor_name} to #{model.name}"
          client.emit_success t('fs3skills.xp_awarded', :name => model.name, :xp => self.xp)
        end
      end
    end
  end
end
