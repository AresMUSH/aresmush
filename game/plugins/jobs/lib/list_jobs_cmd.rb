module AresMUSH
  module Jobs
    class ListJobsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      attr_accessor :page
      
      def want_command?(client, cmd)
        cmd.root_is?("job") && !cmd.args && (cmd.switch.nil? || cmd.switch_is?("all"))
      end
      
      def crack!
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def handle
        jobs = cmd.switch_is?("all") ? 
          Job.all : 
          Job.all.select { |j| j.is_open? || j.is_unread?(client.char) }
          #Job.or( { :status.ne => "DONE" }, {:readers.nin => [client.char.id]} )
          #Job.includes(:readers).where("reader._id" => client.char.id )
  
        jobs = jobs.sort_by { |j| j.number }
        pagination = Paginator.paginate(jobs, self.page, 20)
        if (pagination.out_of_bounds?)
          client.emit BorderedDisplay.text(t('pages.not_that_many_pages'))
        else
          template = JobsListTemplate.new(client.char, pagination.page_items, self.page, pagination.total_pages)
          client.emit template.display
        end
      end
    end
  end
end
