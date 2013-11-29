require 'liquid'

module AresMUSH  
  
  class StripTag < Liquid::Block

      def render(context)
        super.gsub /\n\s*\n/, "\n"
      end

    end
    
    class CenterTag < Liquid::Block

      def initialize(tag_name, params, tokens)
        @width = params.strip.to_i
        @width = @width == 0 ? 78 : @width
        super
     end
        
        def render(context)
          super.center(@width)
        end

      end
      
      class LineTag < Liquid::Tag

        def initialize(tag_name, params, tokens)
          @id = params.strip
          @id = @id.empty? ? 1 : @id
          super
       end
        
          def render(context)
            "%l#{@id}"
          end

        end
    
  class TemplateTest
    def self.test
      
      template = File.read('/Users/lynn/Code/aresmush/game/plugins/who/template.txt')
      vars = {
        "mushname" => "Test MUSH",
        "visible_players" => 
        [
          {
            "name" => "Bob",
            "status" => "IC"
          },
          {
            "name" => "Jane",
            "status" => "OOC"
          }
        ],
        "online_total" => "15 Online",
        "ic_total" => "4 IC",
        "online_record" => "52 Record"
      }
      liq = Liquid::Template.parse(template)
      str = liq.render(vars)
      puts str
      puts ClientFormatter.format(str)
    end
  end
  
  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      Liquid::Template.register_tag('strip', AresMUSH::StripTag)
      Liquid::Template.register_tag('center', AresMUSH::CenterTag)
      Liquid::Template.register_tag('line', AresMUSH::LineTag)
      
      config_reader = ConfigReader.new
      ares_logger = AresLogger.new
      locale = Locale.new
      plugin_factory = PluginFactory.new
      plugin_manager = PluginManager.new(plugin_factory)
      dispatcher = Dispatcher.new(plugin_manager)
      client_factory = ClientFactory.new(dispatcher)
      client_monitor = ClientMonitor.new(dispatcher, client_factory)
      server = Server.new(client_monitor)
      db = Database.new
            
      # Set up global access to the system objects - primarily so that the plugins can 
      # tell them to do things.
      Global.config_reader = config_reader
      Global.client_monitor = client_monitor
      Global.plugin_manager = plugin_manager
      Global.dispatcher = dispatcher
      Global.locale = locale
            
      # Configure a trap for exiting.
      at_exit do
        handle_exit($!)
      end
      
      # Order here is important!
      config_reader.read
      ares_logger.start

      db.connect
      
      locale.setup
      plugin_manager.load_all
    
      Global.logger.debug Global.config

      @command_line = AresMUSH::CommandLine.new(server)
    end
    
    def handle_exit(exception)
      if (exception.kind_of?(SystemExit))
        Global.logger.info "Normal shutdown."
      elsif (exception.nil?)
        Global.logger.info "Shutting down."
      else
        Global.logger.fatal "Abnormal shutdown.  \nLast exception: (#{exception.inspect})\nBacktrace: \n#{exception.backtrace[0,10]}"
      end
    end
    
  end

end