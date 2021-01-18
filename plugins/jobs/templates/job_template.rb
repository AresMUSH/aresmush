module AresMUSH
  module Jobs
    class JobTemplate < ErbTemplateRenderer
            
      attr_accessor :replies, :job
      
      def initialize(enactor, job)
        @enactor = enactor
        @job = job
        @replies = visible_replies
        super File.dirname(__FILE__) + "/job.erb"
      end
     
      def visible_replies
        Jobs.visible_replies(@enactor, job)
      end
      
      def submitted_by
        !@job.author ? t('global.deleted_character') : @job.author.name        
      end
      
      def submitted_on
        OOCTime.local_short_timestr(@enactor, @job.created_at)
      end
      
      def handled_by
        !@job.assigned_to ? t('jobs.unhandled') : @job.assigned_to.name
      end
            
      def title
        "#{@job.id} - #{@job.title}"
      end
      
      def participants
        return t('global.none') if @job.participants.empty?
        @job.participants.map { |p| p.name }.sort.join(", ")
      end
      
      # Title above each reply showing the reply author and date
      def reply_title(reply)
        name = !reply.author ? t('global.deleted_character') : reply.author.name
        date = OOCTime.local_long_timestr(@enactor, reply.created_at)
        t('jobs.reply_title', :name => name, :date => date)
      end

      # Shows a warning if the reply is only visible to admins.
      def reply_admin_only(reply)
        reply.admin_only? ? "%xb#{t('jobs.admin_only')}%xn " : ""
      end
      
      
      def status_color
        Jobs.status_color(@job.status)
      end
      
      def category_color
        Jobs.category_color(@job.job_category.name)
      end
      
      def job_url
        "#{AresMUSH::Game.web_portal_url}/job/#{@job.id}"
      end
    end
  end
end
