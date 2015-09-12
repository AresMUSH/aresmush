module AresMUSH  
  class AsyncTemplateRenderer
    attr_accessor :client
    
    def initialize(client)
      self.client = client
    end
    
    def render
      EM.defer do
        self.client.emit build_template
      end
    end
    
    def build_template
      raise "Not implemented."
    end
  end
end