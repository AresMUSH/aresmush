require_relative "../../plugin_test_loader"

module AresMUSH
  module ICTime
    describe ICTime do
      before do
        allow(Global).to receive(:read_config).with("ictime", "time_ratio") { 1 } 
      end
      
      it "should subtract a year offset" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { -300 } 
        
        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 27) }
        expect(ICTime.ictime).to eq DateTime.new(1714, 01, 27)
      end      

      it "should add a year offset" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 300 } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 27) }
        expect(ICTime.ictime).to eq DateTime.new(2314, 01, 27)
      end      
      
      it "should handle a day offset" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 27) }
        expect(ICTime.ictime).to eq DateTime.new(2114, 01, 29)
      end
      
      it "should handle a hour offset" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 5 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 27, 7, 9) }
        expect(ICTime.ictime).to eq DateTime.new(2114, 01, 29, 12, 9)
      end

      it "should handle a day offset across month boundaries" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { -2 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 01) }
        expect(ICTime.ictime).to eq DateTime.new(2113, 12, 30)
      end
      
      it "should handle a hour offset across day boundaries" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 01, 23, 15) }
        expect(ICTime.ictime).to eq DateTime.new(2114, 01, 02, 01, 15)
      end
      
      it "should handle a day offset that causes an invalid date" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 02, 27) }
        expect(ICTime.ictime).to eq DateTime.new(2114, 03, 01)
      end
      
      it "should show time too" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 27, 5, 55, 23) }
        expect(ICTime.ictime).to eq DateTime.new(2114, 01, 29, 5, 55, 23)
      end
      
      it "should handle a slow time ratio" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 
        allow(Global).to receive(:read_config).with("ictime", "time_ratio") { 0.5 } 
        allow(Global).to receive(:read_config).with("ictime", "game_start_date") { "1/1/2014" } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 21, 0, 0, 0) }
        expect(ICTime.ictime).to eq DateTime.new(2114, 01, 11, 0, 0, 0)
      end

      it "should handle a fast time ratio" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 
        allow(Global).to receive(:read_config).with("ictime", "time_ratio") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "game_start_date") { "1/1/2014" } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 01, 3) } # 2 days elapsed from 1/1 -> 1/3
        expect(ICTime.ictime).to eq DateTime.new(2114, 01, 5)
      end

      it "should handle a time ratio across years" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 
        allow(Global).to receive(:read_config).with("ictime", "time_ratio") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "game_start_date") { "12/20/2014" } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 12, 27) } # 7 days elapsed from 12/20 -> 12/27 means 14 days IC
        expect(ICTime.ictime).to eq DateTime.new(2115, 1, 3)
      end      

      it "should handle a time ratio across years plus a day offset" do
        allow(Global).to receive(:read_config).with("ictime", "hour_offset") { 0 } 
        allow(Global).to receive(:read_config).with("ictime", "day_offset") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "year_offset") { 100 } 
        allow(Global).to receive(:read_config).with("ictime", "time_ratio") { 2 } 
        allow(Global).to receive(:read_config).with("ictime", "game_start_date") { "12/20/2014" } 

        allow(DateTime).to receive(:now) { DateTime.new(2014, 12, 27) } # 7 days elapsed from 12/20 -> 12/27 means 14 days IC
        expect(ICTime.ictime).to eq DateTime.new(2115, 1, 5)
      end      

      
    end
  end
end

