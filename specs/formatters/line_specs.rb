$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe Line do
    describe :show do
      it "is defaults to showing skin line 1" do
        Global.should_receive(:config) { {"skin" => {"line1" => "---"}} }
        Line.show.should eq "---"
      end
      
      it "can read any arbitrary line" do
        Global.should_receive(:config) { {"skin" => {"line_top" => "---"}} }
        Line.show("_top").should eq "---"
      end
      
      it "should default to a blank line if the specified one doesn't exist" do
        Global.should_receive(:config) { {"skin" => {"line1" => "---"}} }
        Line.show("xxx").should eq ""
      end
    end
  end
end