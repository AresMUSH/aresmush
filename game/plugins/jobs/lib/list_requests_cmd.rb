module AresMUSH
  module Jobs
    class ListRequestsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      def initialize
        Jobs.build_renderers
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("requests")
      end
      
      def handle
        requests = cmd.switch_is?("all") ? 
          client.char.submitted_requests : 
          client.char.submitted_requests.select { |r| r.is_open? }

        requests = requests.sort_by { |r| r.number }
        client.emit Jobs.jobs_list_renderer.render(client, requests)
      end
    end
  end
end
