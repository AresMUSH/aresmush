module AresMUSH
  module FS3Skills
    class LuckSpendCmd
      include CommandHandler

      attr_accessor :reason

      def parse_args
        self.reason = trim_arg(cmd.args)
      end

      def required_args
        [ self.reason ]
      end

      def checK_luck
        return t('fs3skills.not_enough_points') if enactor.luck < 1
        return nil
      end

      def handle

        enactor.spend_luck(1)
        message = t('fs3skills.luck_point_spent', :name => enactor_name, :reason => reason)
        enactor_room.emit_ooc message
        Achievements.award_achievement(enactor, "fs3_luck_spent", 'fs3', "Spent a luck point.")

        job_message = t('custom.spent_luck', :name => enactor.name, :reason => self.reason)
        category = Global.read_config("jobs", "luck_category")
        Jobs.create_job(category, t('custom.spent_luck_title', :name => enactor.name), job_message, Game.master.system_character)

        Global.logger.info "#{enactor_name} spent luck on #{reason}."
      end
    end
  end
end
