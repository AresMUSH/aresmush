module AresMUSH
  module Jobs
    class JobSearchCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :category, :value
  
      def initialize
        self.required_args = ['category', 'value']
        self.help_topic = 'jobs'
        super
      end
  
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("search")
      end
  
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.category = cmd.args.arg1 ? trim_input(cmd.args.arg1).downcase : nil
        self.value = cmd.args.arg2
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
          result = ClassTargetFinder.find(self.value, Character, client)
          if (result.found?)
            jobs = Job.where(author: result.target).sort_by { |j| j.number }
          else
            jobs = Job.all.select{ |j| !j.author }.sort_by { |j| j.number }
          end
          
        else
          client.emit_failure t('jobs.invalid_search_category')
          return
        end
        
        template = JobsListTemplate.new(client.char, jobs, 1, 1)
        client.emit template.display          
        
      end
    end
  end
end