module AresMUSH
  module Jobs
    class JobSearchCmd
      include CommandHandler

      attr_accessor :category, :value

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.category = downcase_arg(args.arg1)
        self.value = trim_arg(args.arg2)
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
          jobs = Job.all.select { |j| j.title =~ /#{self.value}/i }.sort_by { |j| j.number }
        elsif (self.category == "submitter")
          result = ClassTargetFinder.find(self.value, Character, enactor)
          if (result.found?)
            jobs = Job.find(author_id: result.target.id).sort_by(:number)
          else
            client.emit_failure t('db.object_not_found')
            return
          end
          
        else
          client.emit_failure t('jobs.invalid_search_category')
          return
        end
        
        paginator = Paginator.paginate(jobs, cmd.page, 20)        
        template = JobsListTemplate.new(enactor, paginator)
        if (paginator.out_of_bounds?)
          client.emit BorderedDisplay.text(t('pages.not_that_many_pages'))
        else
          template = JobsListTemplate.new(enactor, paginator)
          client.emit template.render
        end        
      end
    end
  end
end