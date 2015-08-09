module AresMUSH
  module Jobs
    class ListRequestsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      attr_accessor :page
      
      def want_command?(client, cmd)
        cmd.root_is?("request") && !cmd.args
      end
      
      def crack!
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def handle
        requests = cmd.switch_is?("all") ? 
          client.char.submitted_requests : 
          client.char.submitted_requests.select { |r| r.is_open? || r.is_unread?(client.char) }

        requests = requests.sort_by { |r| r.number }
        pagination = Paginator.paginate(requests, self.page, 20)
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
