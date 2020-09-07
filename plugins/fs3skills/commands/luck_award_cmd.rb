module AresMUSH
  module FS3Skills
    class LuckAwardCmd
      include CommandHandler

      attr_accessor :name, :luck, :reason

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.name = trim_arg(args.arg1)
        self.luck = integer_arg(args.arg2)
        self.reason = args.arg3
      end

      def required_args
        [ self.name, self.luck, self.reason ]
      end


      def check_luck
        # return t('fs3skills.invalid_luck_points') if self.luck.to_f == 0.0
        return nil
      end

      def check_can_award
        return nil if FS3Skills.can_manage_luck?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          model.award_luck(self.luck.to_f)
          Global.logger.info "#{self.luck} Luck Points Awarded by #{enactor_name} to #{model.name} for #{self.reason}"


          job_message = t('custom.awarded_luck', :name => enactor.name, :target => model.name, :luck => self.luck, :reason => self.reason)
          category = Global.read_config("jobs", "luck_category")

          status = Jobs.create_job(Jobs.create_job(category, t('custom.awarded_luck_title', :target => model.name, :luck => self.luck), job_message, model))
          if (status[:job])
            Jobs.close_job(Game.master.system_character, status[:job])
          end



          message = t('fs3skills.luck_awarded', :name => model.name, :luck => self.luck, :reason => self.reason)
          client.emit_success message
          Login.notify(model, :luck, message, nil)



        end
      end
    end
  end
end
