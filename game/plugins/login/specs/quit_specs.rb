require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe QuitCmd do
      include CommandHandlerTestHelper
      
      before do
        init_handler(QuitCmd, "quit")
        SpecHelpers.stub_translate_for_testing        
      end

      describe :handle do
        before do
          handler.crack!
        end
        
        it "should disconnect the client" do
          client.should_receive(:disconnect)
          client.stub(:emit_ooc)
          handler.handle
        end
        
        it "should send the bye text" do
          client.stub(:disconnect)
          client.should_receive(:emit_ooc).with("login.goodbye")
          handler.handle
        end
      end
    end
  end
end