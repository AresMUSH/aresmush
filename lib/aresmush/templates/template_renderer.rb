module AresMUSH  
  class AsyncTemplateRenderer
    attr_accessor :client
    
    def initialize(client)
      self.client = client
    end
    
    def render
      EM.defer do
        AresMUSH.with_error_handling(self.client, "Rendering template:") do        
          self.client.emit build_template
        end
      end
    end
    
    def build_template
      raise "Not implemented."
    end
  end
end