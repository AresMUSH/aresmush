require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    
    describe ChannelJoinCmd do
      include CommandHandlerTestHelper
      
      before do
        @channel = double
        Channel.stub(:find_one).with("Public") { @channel }

        init_handler(ChannelJoinCmd, "channel/join public")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :handle do
        before do
          handler.crack!
        end
        
        context "failure" do
          before do
            @channel.stub(:characters) { [] }
            Channels.stub(:can_use_channel) { true }
            @channel.stub(:default_alias) { ["pu"] }
          end
          
          it "should fail if the channel is not found" do
            Channel.stub(:find_one).with("Public") { nil }
            client.should_receive(:emit_failure).with("channels.channel_doesnt_exist")
            handler.handle
          end
          
          it "should fail if the char is already on that channel" do
            @channel.stub(:characters) { [char] }
            client.should_receive(:emit_failure).with("channels.already_on_channel") 
            handler.handle
          end
          
          it "should fail if the char doesn't have permissions" do
            Channels.stub(:can_use_channel).with(char, @channel) { false }
            client.should_receive(:emit_failure).with("channels.cant_use_channel") 
            handler.handle
          end
          
          it "should fail if the alias is already in use" do
            char.stub(:channel_options) { { "Other" => { "alias" => ["pu"] } } }
            Channel.stub(:find_one).with("Other") { double }
            client.should_receive(:emit_failure).with("channels.alias_in_use") 
            client.should_receive(:emit_failure).with("channels.unable_to_determine_auto_alias") 
            handler.handle
          end
        end

        context "success" do
          before do
            @channel.stub(:name) { "Public" }
            Channels.stub(:channel_for_alias) { nil }
            Channels.stub(:can_use_channel) { true }
            @chars = []
            @channel.stub(:save)
            @channel.stub(:emit)
            @channel.stub(:characters) { @chars }
            @channel.stub(:default_alias) { ["pu"] }
            char.stub(:channel_options) { {} }
            char.stub(:save)
            char.stub(:name) { "Bob" }
            client.stub(:emit_success)
          end
          
          it "should announce the channel join" do
            @channel.should_receive(:emit).with('channels.joined_channel')
            handler.handle
          end
          
          it "should set the channel alias to the default if none specified" do
            Channels.should_receive(:set_channel_option).with(char, @channel, "alias", ["pu" ])
            char.should_receive(:save)
            handler.handle
          end

          it "should set the channel alias to a user-selected value if specified" do
            handler.stub(:alias) { "=pub" }
            Channels.should_receive(:set_channel_option).with(char, @channel, "alias", ["=pub"])
            char.should_receive(:save)
            handler.handle
          end

          it "should tell the character the channel alias" do
            client.should_receive(:emit_success).with('channels.channel_alias_set')
            handler.handle
          end
                    
          it "should add the char to the channel" do
            @channel.should_receive(:save)
            handler.handle
            @channel.characters.should eq [char]
          end
        end
      end
    end
  end
end