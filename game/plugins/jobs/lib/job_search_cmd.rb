module AresMUSH
  module Jobs
    class JobSearchCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :category, :value

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.category = cmd.args.arg1 ? trim_input(cmd.args.arg1).downcase : nil
        self.value = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.category, self.value ],
          help: 'jobs'
        }
      end
      
      def check_category
        categories = [ 'title', 'submitter' ]
        return  if (!categories.include?(self.category))
        return nil
      end
  
      def handle
        if (self.category == "title")
          jobs = Job.where(title: /#{self.value}/i).sort_by { |j| j.number }
        elsif (self.category == "submitter")
          result = ClassTargetFinder.find(self.value, Character, enactor)
          if (result.found?)
            jobs = Job.where(author: result.target).sort_by { |j| j.number }
          else
            jobs = Job.all.select{ |j| !j.author }.sort_by { |j| j.number }
          end
          
        else
          client.emit_failure t('jobs.invalid_search_category')
          return
        end
        
        template = JobsListTemplate.new(enactor, jobs, 1, 1)
        client.emit template.display          
        
      end
    end
  end
end