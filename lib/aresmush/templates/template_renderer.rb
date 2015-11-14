module AresMUSH  
  class AsyncTemplateRenderer
    include EM::Deferrable

    attr_accessor :client
    
    def initialize(client)
      self.client = client
    end
    
    # Renders the template asynchronously and emits it to the client when done
    def render
      #self.callback { |text| Global.dispatcher.queue_action(self.client) { self.client.emit text } }
      #build_async
      self.client.emit build      
    end
    
    # Builds the template asynchronously.  To get the data, set up a callback.
    #    template = MyTemplate.new
    #    template.callback { |text| do something with the template text }
    #    template.build_async
    def build_async
      callback = Proc.new { |text| self.succeed text }
      Global.dispatcher.spawn("Building template #{self.class.name}.", self.client, callback) do
        build
      end
    end
    
    # Builds the template.  This is a blocking call.
    def build
      raise "Not implemented."
    end
  end
end