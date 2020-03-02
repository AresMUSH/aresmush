require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    
    describe Channels do

      before do
        @channel = double
        @char = double
        @options = double
        stub_translate_for_testing
      end
      
      describe :join_channel do
        before do
          allow(Channel).to receive(:find_one_by_name).with("pub") { @channel }
          allow(Channels).to receive(:is_on_channel?) { false }
          allow(Channels).to receive(:can_join_channel?) { true }
          allow(Channels).to receive(:get_channel_options) { @options }
        end
        
        it "should fail if already on channel" do
          expect(Channels).to receive(:is_on_channel?).with(@char, @channel) { true }
          expect(Channels.join_channel(@channel, @char, nil)).to eq 'channels.already_on_channel'
        end
        
        it "should fail if can't access channel" do
          expect(Channels).to receive(:can_join_channel?).with(@char, @channel) { false }
          expect(Channels.join_channel(@channel, @char, nil)).to eq 'channels.cant_use_channel'
        end
        
        it "should fail if alias already in use" do
          expect(Channels).to receive(:set_channel_alias).with(nil, @char, @channel, "pub", false) { 'channels.unable_to_determine_auto_alias' }
          expect(Channels.join_channel(@channel, @char, "pub")).to eq 'channels.unable_to_determine_auto_alias'
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
            allow(@channel).to receive(:default_alias) { [ "pub" ]}
            allow(@char).to receive(:name) { "Bob" }
          end
          
          it "should use default alias if none specified" do
            expect(Channels).to receive(:set_channel_alias).with(nil, @char, @channel, "pub", false) { nil }
            Channels.join_channel(@channel, @char, nil)
          end
        
          it "should use alias if specified" do
            expect(Channels).to receive(:set_channel_alias).with(nil, @char, @channel, "p2", false) { nil }
            Channels.join_channel(@channel, @char, "p2")
          end
        
          it "should add the char to the channel" do
            expect(Channels).to receive(:set_channel_alias).with(nil, @char, @channel, "p", false) { nil }
            expect(@chars_stub).to receive(:<<).with(@char) {}
            Channels.join_channel(@channel, @char, "p")
          end
        end
      end  
    end
  end
end
