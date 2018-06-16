require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    
    describe Channels do

      before do
        @channel = double
        @char = double
        @client = double
        @options = double
        stub_translate_for_testing
      end
        
      describe :join_channel do
        before do
          allow(Channel).to receive(:find_one_by_name).with("pub") { @channel }
          allow(Channels).to receive(:is_on_channel?) { false }
          allow(Channels).to receive(:can_use_channel) { true }
          allow(Channels).to receive(:get_channel_options) { @options }
        end
        
        it "should fail if already on channel" do
          expect(Channels).to receive(:is_on_channel?).with(@char, @channel) { true }
          expect(@client).to receive(:emit_failure).with('channels.already_on_channel')
          Channels.join_channel("pub", @client, @char, nil)
        end
        
        it "should fail if can't access channel" do
          expect(Channels).to receive(:can_use_channel).with(@char, @channel) { false }
          expect(@client).to receive(:emit_failure).with('channels.cant_use_channel')
          Channels.join_channel("pub", @client, @char, nil)
        end
        
        it "should fail if alias already in use" do
          expect(Channels).to receive(:set_channel_alias).with(@client, @char, @channel, "pub", false) { false }
          expect(@client).to receive(:emit_failure).with('channels.unable_to_determine_auto_alias')
          Channels.join_channel("pub", @client, @char, "pub")
        end
        
        context "success" do
          before do
            allow(Channels).to receive(:set_channel_alias) { true }
            allow(@options).to receive(:alias_hint) { "Hint" }
            @chars_stub = double
            allow(@chars_stub).to receive(:<<) {}
            allow(@channel).to receive(:characters) { @chars_stub }
            allow(@channel).to receive(:save)
            allow(Channels).to receive(:emit_to_channel) {}
            allow(@char).to receive(:name) { "Bob" }
          end
          
          it "should use default alias if none specified" do
            allow(@channel).to receive(:default_alias) { [ "pub" ]}
            expect(Channels).to receive(:set_channel_alias).with(@client, @char, @channel, "pub", false) { true }
            Channels.join_channel("pub", @client, @char, nil)
          end
        
          it "should use alias if specified" do
            allow(@channel).to receive(:default_alias) { [ "pub" ]}
            expect(Channels).to receive(:set_channel_alias).with(@client, @char, @channel, "p2", false) { true }
            Channels.join_channel("pub", @client, @char, "p2")
          end
        
          it "should add the char to the channel" do
            expect(@chars_stub).to receive(:<<).with(@char) {}
            Channels.join_channel("pub", @client, @char, "p")
          end
        end
      end  
    end
  end
end
