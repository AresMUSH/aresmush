module AresMUSH
  module Jobs
    class JobChangeParticipantCmd
      include CommandHandler

      attr_accessor :number, :participant, :add_participant
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.number = trim_arg(args.arg1)
        self.participant = titlecase_arg(args.arg2)
        self.add_participant = cmd.switch_is?("addparticipant")
      end
      
      def required_args
        [ self.number, self.participant ]
      end
      
      def check_number
        return nil if !self.number
        return t('jobs.invalid_job_number') if !self.number.is_integer?
        return nil
      end
      
      def handle
        job = Job[number]
        if (!job)
          client.emit_failure t('jobs.invalid_job_number')
          return
        end
        
        error = Jobs.check_job_access(enactor, job, true)
        if (error)
          client.emit_failure error
          return
        end
        
        ClassTargetFinder.with_a_character(self.participant, client, enactor) do |model|
          if (self.add_participant)
            if (job.participants.include?(model))
              client.emit_failure t('jobs.participant_already_exists', :name => model.name)
              return
            end
            job.participants.add model
            message = t('jobs.participant_added', :name => enactor.name, :num => job.id, :participant => model.name)
            Jobs.notify(job, message, enactor)
          else
            if (!job.participants.include?(model))
              client.emit_failure t('jobs.participant_doesnt_exist', :name => model.name)
              return
            end
            job.participants.delete model
            message = t('jobs.participant_removed', :name => enactor.name, :num => job.id, :participant => model.name)
            Jobs.notify(job, message, enactor)
          end
        end
        
        
      end
    end
  end
end
