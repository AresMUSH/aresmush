module AresMUSH
  module Jobs
    class ListRequestsCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("requests")
      end
      
      def handle
        reqs = []
        requests = cmd.switch_is?("all") ? 
          client.char.submitted_requests : 
          client.char.submitted_requests.select { |r| r.is_open? }
        
        requests.each do |r, i|
          reqs << "* #{r.number} #{r.status} #{r.is_open?} #{r.title}"
        end
        
        client.emit BorderedDisplay.list(reqs)
      end
    end
  end
end
