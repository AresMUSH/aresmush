require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
    describe Character do
      describe :outfit do
        before do
          @char = Character.new
          @char.outfits = { 'foo' => 'foo desc', 'bar' => 'bar desc' }
        end
        
        it "should return nil if the outfit doesn't exist" do
          @char.outfit("zzz").should eq nil
        end

        it "should get the outfit by name" do
          @char.outfit('foo').should eq 'foo desc'
        end
      end
    end
  end
end
