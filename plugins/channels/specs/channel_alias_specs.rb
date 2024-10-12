require "plugin_test_loader"

module AresMUSH
  module Channels
    describe :channel_for_alias do
      before do
        @char = double
        @channel = double
        allow(Channel).to receive(:find_one_by_name).with("Public") { @channel }
      end
      
      context "Alias has a prefix" do
        before do
          @options = double
          allow(@options).to receive(:channel) { @channel }
          allow(@options).to receive(:match_alias).with('pub') { true }
          allow(@char).to receive(:channel_options) { [@options] }
          allow(Channels).to receive(:get_channel_options).with(@char, @channel) { @options }
        end

        it "should match the alias exactly" do
          expect(Channels.channel_for_alias(@char, "+pub")).to eq @channel
        end
      
        it "should match the alias without a prefix" do
          expect(Channels.channel_for_alias(@char, "pub")).to eq @channel
        end

        it "should match the alias with a different prefix" do
          expect(Channels.channel_for_alias(@char, "=pub")).to eq @channel
        end
      end
      
      context "Alias does not match" do
        before do
          @options = double
          allow(@options).to receive(:channel) { @channel }
          allow(@options).to receive(:match_alias).with('pub') { false }
          allow(@char).to receive(:channel_options) { [@options] }
          allow(Channels).to receive(:get_channel_options).with(@char, @channel) { @options }
        end

        it "should match the alias exactly" do
          allow(Channel).to receive(:all) { [] }
          expect(Channels.channel_for_alias(@char, "pub")).to eq nil
        end
      end
    end
  end
end
