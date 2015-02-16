require_relative "../../plugin_test_loader"

module AresMUSH
  module Channels
    describe :channel_for_alias do
      before do
        @char = double
        @channel = double
        Channel.stub(:find_by_name).with("Public") { @channel }
      end
      
      context "Alias has a prefix" do
        before do
          @char.stub(:channel_options) { { "Public" => { "alias" => ["+pub"] } }}
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
      
      context "Alias does not have a prefix" do
        before do
          @char.stub(:channel_options) { { "Public" => { "alias" => ["pub"] } }}
        end

        it "should match the alias exactly" do
          Channels.channel_for_alias(@char, "pub").should eq @channel
        end
      
        it "should match the alias with a prefix" do
          Channels.channel_for_alias(@char, "+pub").should eq @channel
        end
      end
      
      
    end
  end
end