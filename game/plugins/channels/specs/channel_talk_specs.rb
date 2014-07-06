require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    
    describe ChannelTalkCmd do
      include PluginCmdTestHelper
      
      before do
        @channel = double
        Channel.stub(:find_by_name).with("Public") { @channel }

        init_handler(ChannelTalkCmd, "+pub Hi.")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :want_command? do
        before do
          Channels.stub(:channel_for_alias).with(char, "pub") { @channel }
          Channels.stub(:channel_for_alias).with(char, "oth") { nil }
          client.stub(:logged_in?) { true }
        end
        
        it "should want the cmd if the command matches an alias" do
          cmd = Command.new("+pub Hi.")
          handler.want_command?(client, cmd).should be_true
        end
        
        it "should set the channel if found" do
          cmd = Command.new("+pub Hi.")
          handler.want_command?(client, cmd).should be_true
          handler.channel.should eq @channel
        end
        
        it "should not want the cmd if no matching alias found" do
          cmd = Command.new("+oth Hi.")
          handler.want_command?(client, cmd).should be_false
        end
        
        it "should not want the command if not logged in" do
          cmd = Command.new("+pub Hi.")
          client.stub(:logged_in?) { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
      
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
            client.stub(:name) { "Bob" }
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
            @channel.stub(:characters) { [] }
            client.should_receive(:emit_failure).with('channels.not_on_channel')
            handler.handle
          end
        end
      end
    end
  end
end