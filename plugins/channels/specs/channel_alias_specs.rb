require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    describe :channel_for_alias do
      before do
        @char = double
        @channel = double
        Channel.stub(:find_one_by_name).with("Public") { @channel }
      end
      
      context "Alias has a prefix" do
        before do
          @options = double
          @options.stub(:channel) { @channel }
          @options.stub(:match_alias).with('pub') { true }
          @char.stub(:channel_options) { [@options] }
          Channels.stub(:get_channel_options).with(@char, @channel) { @options }
        end

        it "should match the alias exactly" do
          Channels.channel_for_alias(@char, "+pub").should eq @channel
        end
      
        it "should match the alias without a prefix" do
          Channels.channel_for_alias(@char, "pub").should eq @channel
        end

        it "should match the alias with a different prefix" do
          Channels.channel_for_alias(@char, "=pub").should eq @channel
        end
      end
      
      context "Alias does not match" do
        before do
          @options = double
          @options.stub(:channel) { @channel }
          @options.stub(:match_alias).with('pub') { false }
          @char.stub(:channel_options) { [@options] }
          Channels.stub(:get_channel_options).with(@char, @channel) { @options }
        end

        it "should match the alias exactly" do
          Channel.stub(:all) { [] }
          Channels.channel_for_alias(@char, "pub").should eq nil
        end
      end
    end
  end
end