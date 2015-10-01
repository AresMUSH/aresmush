$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandLine do
    describe :start do
      it "should start the server" do
        server = double(Server)
        Game.stub(:master) { double(Game) }
        command_line = CommandLine.new(server)
        server.should_receive(:start)
        command_line.start
      end
    end
  end
  
  describe Database do
    describe :mongotest do
      begin
        config = YAML.load_file(File.join(AresMUSH.game_path, "config", "database.yml"))
        puts config
        Mongoid.load_configuration(config["database"]["production"])
        
        Mongoid.logger.level = Logger::WARN
        Mongo::Logger.logger.level = Logger::WARN            
          
        puts "Models:"
        puts Mongoid.models
        puts "Storage:"
        puts "Defaults: #{Character.storage_options_defaults}"
        puts "Current: #{Character.storage_options}"
        puts "Count:"
        puts Character.all.count.should eq 0
                
                        
      rescue Exception => e
        Global.logger.fatal("Error loading database config.  Please check your dabase configuration and installation requirements: #{e}.")      
        raise e
      end      
    end
  end
end