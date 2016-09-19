module AresMUSH  
  
  class ErbTemplateRenderer
    attr_accessor :client

    def initialize(file, client)
      template = File.read(file)
      @template = Erubis::Eruby.new(template, :bufvar=>'@output')
      self.client = client
    end
      		      
    def build
      @template.evaluate(self)
    end		
    
    def render
      self.client.emit build
    end      
  end
        
        
  class AsyncTemplateRenderer
    attr_accessor :client
    
    #include EM:Deferrable
    
    def initialize(client)
      self.client = client
    end
    
    # Renders the template asynchronously and emits it to the client when done
    def render
      self.client.emit build
    end
    
    # Builds the template asynchronously.  To get the data, set up a callback.
    #    template = MyTemplate.new
    #    template.callback { |text| do something with the template text }
    #    template.build_async
    #def build_async
    #  callback = Thread.new { |text| self.succeed text }
    #  puts "Building async"
    #  Global.dispatcher.spawn("Building template #{self.class.name}.", self.client, callback) do
    #    build
    #  end
    #end
    
    # Builds the template.  This is a blocking call, so normally it should be called from 'render'
    def build
      raise "Not implemented."
    end
  end
end