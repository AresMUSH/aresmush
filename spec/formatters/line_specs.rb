$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe Line do
    describe :show do
      it "is defaults to showing header" do
        Global.should_receive(:read_config).with("skin", "header") { "---" } 
        Line.show.should eq "---"
      end
      
      it "can read any arbitrary line" do
        Global.should_receive(:read_config).with("skin", "line_top") { "---" } 
        Line.show("line_top").should eq "---"
      end
      
      it "should default to a blank line if the specified one doesn't exist" do
        Global.should_receive(:read_config).with("skin", "xxx") { nil } 
        Line.show("xxx").should eq ""
      end
    end
  end
end