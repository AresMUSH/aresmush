module AresMUSH
  module Jobs
    class JobTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
      attr_accessor :replies, :job
      
      def initialize(client, job)
        @char = client.char
        @client = client
        @job = job
        @replies = Jobs.can_access_jobs?(client.char) ? job.job_replies : job.job_replies.select { |r| !r.admin_only}
        super File.dirname(__FILE__) + "/job.erb"
      end
     
      def submitted_by
        @job.author.nil? ? t('jobs.deleted_author') : @job.author.name        
      end
      
      def submitted_on
        OOCTime::Api.local_short_timestr(@client, @job.created_at)
      end
      
      def handled_by
        @job.assigned_to.nil? ? t('jobs.unhandled') : @job.assigned_to.name
      end
            
      def title
        "#{@job.number} - #{@job.title}"
      end
      
      # Title above each reply showing the reply author and date
      def reply_title(reply)
        name = reply.author.nil? ? t('jobs.deleted_author') : reply.author.name
        date = OOCTime::Api.local_long_timestr(@client, reply.created_at)
        t('jobs.reply_title', :name => name, :date => date)
      end

      # Shows a warning if the reply is only visible to admins.
      def reply_admin_only(reply)
        reply.admin_only? ? "%xb#{t('jobs.admin_only')}%xn " : ""
      end
    end
  end
end
