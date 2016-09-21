require_relative "../../plugin_test_loader"

module AresMUSH
  module Utils
    describe EchoCmd do
      include CommandHandlerTestHelper
    
      before do
        init_handler(EchoCmd, "echo happy thoughts")
        SpecHelpers.stub_translate_for_testing        
      end      

      describe :handle do
        it "should echo back to the client" do
          handler.crack!
          client.should_receive(:emit).with("happy thoughts")
          handler.handle
        end        
      end
    end
  end
end