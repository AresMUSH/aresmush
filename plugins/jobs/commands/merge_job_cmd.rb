module AresMUSH
  module Jobs

    class JobMergeCmd
      include CommandHandler
      
      attr_accessor :from_job_number, :to_job_number
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.from_job_number = integer_arg(args.arg1)
        self.to_job_number = integer_arg(args.arg2)
      end
      
      def required_args
        [ self.from_job_number, self.to_job_number ]
      end
      
      def handle
        Jobs.with_a_job(enactor, client, self.from_job_number) do |from_job|
          
          Jobs.with_a_job(enactor, client, self.to_job_number) do |to_job|
            
            reply_update_msg = t('jobs.reply_moved', :from => from_job.id)
            
            from_job.job_replies.each do |reply|
              reply.update(message: "#{reply.message}%R%R#{reply_update_msg}")
              reply.update(job: to_job)              
            end
            
            Jobs.close_job(enactor, from_job, t('jobs.jobs_merged_to', :to => to_job.id))
            to_job.update(description: "#{to_job.description}%R%R----%R%R#{from_job.description}")
            Jobs.comment(to_job, enactor, t('jobs.jobs_merged_from', :from => from_job.id), false)
          end
          
        end
      end
    end        
  end
end
