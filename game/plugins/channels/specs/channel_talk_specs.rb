require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    
    describe ChannelTalkCmd do
      include CommandHandlerTestHelper
      
      before do
        @channel = double
        Channel.stub(:find_one).with("Public") { @channel }

        init_handler(ChannelTalkCmd, "+pub Hi.")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      
      describe :handle do
        before do
          handler.stub(:channel) { @channel }
          handler.crack!
        end
        
        context "success" do
          before do
            @channel.stub(:emit)
            @channel.stub(:characters) { [char] }
            @channel.stub(:name) { "Public" }
            char.stub(:ooc_name) { "Bob" }
          end
          
          it "should include the title in the name if set" do
            char.stub(:channel_options) { { "Public" => { "title" => "My Title" } } }
            @channel.should_receive(:pose).with("My Title Bob", "Hi.")
            handler.handle
          end
          
          it "should include just the name if no title set" do
            char.stub(:channel_options) { { "Public" => { } } }
            @channel.should_receive(:pose).with("Bob", "Hi.")
            handler.handle
          end
          
          it "should emit failure if the char is not on the channel" do
            char.stub(:channel_options) { { "Public" => { } } }
            @channel.stub(:characters) { [] }
            client.should_receive(:emit_failure).with('channels.not_on_channel')
            handler.handle
          end
        end
      end
    end
  end
end