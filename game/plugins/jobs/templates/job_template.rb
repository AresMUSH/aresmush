module AresMUSH
  module Jobs
    # Template for an individual job
    class JobTemplate
      include TemplateFormatters
            
      attr_accessor :replies
      
      def initialize(client, job, replies)
        @char = client.char
        @client = client
        @job = job
        @replies = replies
      end
      
      def display
        text = "%l1%r"
        text << "%xh#{ title }%xn%r"
        text << "%r"
        text << "#{ category_title } #{ category }%r"
        text << "#{ submitted_by_title } #{ submitted_by }"
        text << "    #{ submitted_on_title } #{ submitted_on }%r"
        text << "#{ status_title } #{ status }"
        text << "    #{ handled_by_title } #{ handled_by }%r"
        text << "%r"
        text << "#{ description_title }%r"
        text << "#{ description }"
        replies.each do |r|
          text << "%r%l2%r"
          text << reply_admin_only(r)
          text << reply_title(r)
          text << "%r"
          text << reply_message(r)
        end
        text << "%r%l1"
        
        text
      end
      
      def category_title
        field_title(t('jobs.category_title'))
      end
      
      def status_title
        field_title(t('jobs.status_title'))
      end
      
      def submitted_by_title
        field_title(t('jobs.submitted_by_title'))
      end
      
      def submitted_on_title
        field_title(t('jobs.submitted_on_title'))
      end
      
      def handled_by_title
        field_title(t('jobs.handled_by_title'))
      end
      
      def field_title(title)
        "%xh#{left(title, 15)}%xn"
      end
      
      def description_title
        "%xh#{t('jobs.description')}%xn"
      end
      
      def replies_title
        "%xh%#{t('jobs.replies')}%xn"
      end
      
      # Job number and title, centered
      def title
        center("##{@job.number} - #{@job.title}", 78)
      end
      
      def category
        @job.category
      end
      
      def status
        left(@job.status, 20)
      end
      
      def handled_by
        name = @job.assigned_to.nil? ? t('jobs.unhandled') : @job.assigned_to.name
        left(name, 17)
      end
      
      def submitted_by
        name = @job.author.nil? ? t('jobs.deleted_author') : @job.author.name
        left(name, 20)
      end
      
      def description
        @job.description
      end
      
      def submitted_on
        OOCTime.local_short_timestr(@client, @job.created_at)
      end
      
      # Title above each reply showing the reply author and date
      def reply_title(reply)
        name = reply.author.nil? ? t('jobs.deleted_author') : reply.author.name
        date = OOCTime.local_long_timestr(@client, reply.created_at)
        t('jobs.reply_title', :name => name, :date => date)
      end

      def reply_message(reply)
        reply.message
      end
      
      # Shows a warning if the reply is only visible to admins.
      def reply_admin_only(reply)
        reply.admin_only? ? "%xb#{t('jobs.admin_only')}%xn " : ""
      end
    end
  end
end
