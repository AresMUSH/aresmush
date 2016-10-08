require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    
    describe Channels do

      before do
        @channel = double
        @char = double
        @client = double
        @options = double
        SpecHelpers.stub_translate_for_testing
      end
        
      describe :join_channel do
        before do
          Channel.stub(:find_one_by_name).with("pub") { @channel }
          Channels.stub(:is_on_channel?) { false }
          Channels.stub(:can_use_channel) { true }
          Channels.stub(:get_channel_options) { @options }
        end
        
        it "should fail if already on channel" do
          Channels.should_receive(:is_on_channel?).with(@char, @channel) { true }
          @client.should_receive(:emit_failure).with('channels.already_on_channel')
          Channels.join_channel("pub", @client, @char, nil)
        end
        
        it "should fail if can't access channel" do
          Channels.should_receive(:can_use_channel).with(@char, @channel) { false }
          @client.should_receive(:emit_failure).with('channels.cant_use_channel')
          Channels.join_channel("pub", @client, @char, nil)
        end
        
        it "should fail if alias already in use" do
          Channels.should_receive(:set_channel_alias).with(@client, @char, @channel, "pub", false) { false }
          @client.should_receive(:emit_failure).with('channels.unable_to_determine_auto_alias')
          Channels.join_channel("pub", @client, @char, "pub")
        end
        
        context "success" do
          before do
            Channels.stub(:set_channel_alias) { true }
            @options.stub(:alias_hint) { "Hint" }
            @chars_stub = double
            @chars_stub.stub(:<<) {}
            @channel.stub(:characters) { @chars_stub }
            @channel.stub(:save)
            @channel.stub(:emit) {}
            @char.stub(:name) { "Bob" }
          end
          
          it "should use default alias if none specified" do
            @channel.stub(:default_alias) { [ "pub" ]}
            Channels.should_receive(:set_channel_alias).with(@client, @char, @channel, "pub", false) { true }
            Channels.join_channel("pub", @client, @char, nil)
          end
        
          it "should use alias if specified" do
            @channel.stub(:default_alias) { [ "pub" ]}
            Channels.should_receive(:set_channel_alias).with(@client, @char, @channel, "p2", false) { true }
            Channels.join_channel("pub", @client, @char, "p2")
          end
        
          it "should add the char to the channel" do
            @chars_stub.should_receive(:<<).with(@char) {}
            @channel.should_receive(:save)
            Channels.join_channel("pub", @client, @char, "p")
          end
        end
      end  
    end
  end
end