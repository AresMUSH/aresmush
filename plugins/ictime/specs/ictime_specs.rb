require_relative "../../plugin_test_loader"

module AresMUSH
  module ICTime
    describe ICTime do
      before do
        Global.stub(:read_config).with("ictime", "time_ratio") { 1 } 
      end
      
      it "should subtract a year offset" do
        Global.stub(:read_config).with("ictime", "day_offset") { 0 } 
        Global.stub(:read_config).with("ictime", "year_offset") { -300 } 
        
        DateTime.stub(:now) { DateTime.new(2014, 01, 27) }
        ICTime.ictime.should eq DateTime.new(1714, 01, 27)
      end      

      it "should add a year offset" do
        Global.stub(:read_config).with("ictime", "day_offset") { 0 } 
        Global.stub(:read_config).with("ictime", "year_offset") { 300 } 

        DateTime.stub(:now) { DateTime.new(2014, 01, 27) }
        ICTime.ictime.should eq DateTime.new(2314, 01, 27)
      end      
      
      it "should handle a day offset" do
        Global.stub(:read_config).with("ictime", "day_offset") { 2 } 
        Global.stub(:read_config).with("ictime", "year_offset") { 100 } 

        DateTime.stub(:now) { DateTime.new(2014, 01, 27) }
        ICTime.ictime.should eq DateTime.new(2114, 01, 29)
      end

      it "should handle a day offset across month boundaries" do
        Global.stub(:read_config).with("ictime", "day_offset") { -2 } 
        Global.stub(:read_config).with("ictime", "year_offset") { 100 } 

        DateTime.stub(:now) { DateTime.new(2014, 01, 01) }
        ICTime.ictime.should eq DateTime.new(2113, 12, 30)
      end
      
      it "should handle a day offset that causes an invalid date" do
        Global.stub(:read_config).with("ictime", "day_offset") { 2 } 
        Global.stub(:read_config).with("ictime", "year_offset") { 100 } 

        DateTime.stub(:now) { DateTime.new(2014, 02, 27) }
        ICTime.ictime.should eq DateTime.new(2114, 03, 01)
      end
      
      it "should show time too" do
        Global.stub(:read_config).with("ictime", "day_offset") { 2 } 
        Global.stub(:read_config).with("ictime", "year_offset") { 100 } 

        DateTime.stub(:now) { DateTime.new(2014, 01, 27, 5, 55, 23) }
        ICTime.ictime.should eq DateTime.new(2114, 01, 29, 5, 55, 23)
      end
      
      it "should handle a slow time ratio" do
        Global.stub(:read_config).with("ictime", "day_offset") { 0 } 
        Global.stub(:read_config).with("ictime", "year_offset") { 100 } 
        Global.stub(:read_config).with("ictime", "time_ratio") { 0.5 } 
        Global.stub(:read_config).with("ictime", "game_start_date") { "1/1/2014" } 

        DateTime.stub(:now) { DateTime.new(2014, 01, 21, 0, 0, 0) }
        ICTime.ictime.should eq DateTime.new(2114, 01, 11, 0, 0, 0)
      end

      it "should handle a fast time ratio" do
        Global.stub(:read_config).with("ictime", "day_offset") { 0 } 
        Global.stub(:read_config).with("ictime", "year_offset") { 100 } 
        Global.stub(:read_config).with("ictime", "time_ratio") { 2 } 
        Global.stub(:read_config).with("ictime", "game_start_date") { "1/1/2014" } 

        DateTime.stub(:now) { DateTime.new(2014, 01, 3) } # 2 days elapsed from 1/1 -> 1/3
        ICTime.ictime.should eq DateTime.new(2114, 01, 5)
      end
      
    end
  end
end

