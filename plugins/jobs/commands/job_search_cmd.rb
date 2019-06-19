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
        [ self.category, self.value ]
      end
      
      def check_category
        categories = [ 'title', 'submitter' ]
        return  if (!categories.include?(self.category))
        return nil
      end
  
      def handle
        if (self.category == "title")
          jobs = Jobs.accessible_jobs(enactor).select { |j| j.title =~ /#{self.value}/i }
        elsif (self.category == "submitter")
          submitter = Character.named(self.value)
          if (submitter)
            jobs = Jobs.accessible_jobs(enactor).select { |j| j.author == submitter }
          else
            client.emit_failure t('db.object_not_found')
            return
          end
        else
          client.emit_failure t('jobs.invalid_search_category')
          return
        end
        
        jobs = jobs.sort_by { |j| j.created_at }
        paginator = Paginator.paginate(jobs, cmd.page, 9999)        
        template = JobsListTemplate.new(enactor, paginator, t('jobs.job_filter_tip'))
        if (paginator.out_of_bounds?)
          template = BorderedDisplayTemplate.new t('pages.not_that_many_pages')
          client.emit template.render
        else
          template = JobsListTemplate.new(enactor, paginator, t('jobs.job_filter_tip'))
          client.emit template.render
        end        
      end
    end
  end
end