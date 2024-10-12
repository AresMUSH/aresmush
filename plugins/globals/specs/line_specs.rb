

require "aresmush"

module AresMUSH
  describe Line do
    describe :show do
      it "is defaults to showing header" do
        expect(Global).to receive(:read_config).with("skin", "header") { "---" } 
        expect(Line.show).to eq "---"
      end
      
      it "can read any arbitrary line" do
        expect(Global).to receive(:read_config).with("skin", "line_top") { "---" } 
        expect(Line.show("line_top")).to eq "---"
      end
      
      it "should default to a blank line if the specified one doesn't exist" do
        expect(Global).to receive(:read_config).with("skin", "xxx") { nil } 
        expect(Line.show("xxx")).to eq ""
      end
    end
  end
end
