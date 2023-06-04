

require "aresmush"

module AresMUSH

  describe ProgressBarFormatter do
    describe :format do
      it "should show zero progress" do
        expect(ProgressBarFormatter.format(0, 10)).to eq ".........."
      end

      it "should show negative progress as zero" do
        expect(ProgressBarFormatter.format(-1, 10)).to eq ".........."
      end

      it "should handle nil progress" do
        expect(ProgressBarFormatter.format(nil, 10)).to eq ".........."
      end
            
      it "should show complete progress" do
        expect(ProgressBarFormatter.format(10, 10)).to eq "@@@@@@@@@@"
      end

      it "should show excess progress as complete" do
        expect(ProgressBarFormatter.format(11, 10)).to eq "@@@@@@@@@@"
      end

      it "should show partial progress" do
        expect(ProgressBarFormatter.format(5, 10)).to eq "@@@@@....."
      end

      it "should round down partial progress" do
        expect(ProgressBarFormatter.format(5, 12)).to eq "@@@@......"
      end

      it "should not round down partial progress to zero" do
        expect(ProgressBarFormatter.format(1, 20)).to eq "@........."
      end

      context "compressed scale of 5" do
        it "should show partial progress" do
          expect(ProgressBarFormatter.format(5, 10, 5)).to eq "@@..."
        end

        it "should show complete progress" do
          expect(ProgressBarFormatter.format(10, 10, 5)).to eq "@@@@@"
        end
      end

      context "compressed scale of 2" do
        it "should show partial progress" do
          expect(ProgressBarFormatter.format(5, 10, 2)).to eq "@."
        end

        it "should show complete progress" do
          expect(ProgressBarFormatter.format(10, 10, 2)).to eq "@@"
        end
      end
      
      context "custom chars" do
        it "should let you override the display" do
          expect(ProgressBarFormatter.format(5, 10, 10, "*", "-")).to eq "*****-----"
        end
      end
      
    end
  end
end
