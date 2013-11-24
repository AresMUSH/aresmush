$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe AresLogger do
    describe :start do
      it "should start the logger with the logger config" do
        logger_config = { "a" => "b", "c" => "d" }
        Global.stub(:config) { {"logger" => logger_config}  }
        logger = AresLogger.new
        Log4r::YamlConfigurator.should_receive(:decode_yaml).with(logger_config)
        logger.start
      end
    end
    
    describe :logger do
      it "should ask for the ares logger" do
        Log4r::Logger.should_receive(:[]).with('ares')
        Global.logger
      end
      
      it "should return the ares logger if it's set" do
        dummy_logger = double(AresLogger)
        Log4r::Logger.stub(:[]).with('ares') { dummy_logger }
        Global.logger.should eq dummy_logger
      end
      
      it "should return the root logger if the ares logger is not set" do
        dummy_logger = Object.new
        Log4r::Logger.stub(:[]).with('ares') { nil }
        Log4r::Logger.stub(:root) { dummy_logger }
        Global.logger.should eq dummy_logger
      end
      
    end
  end
end