$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ProgressBarFormatter do
    describe :format do
      it "should show zero progress" do
        ProgressBarFormatter.format(0, 10).should eq ".........."
      end

      it "should show negative progress as zero" do
        ProgressBarFormatter.format(-1, 10).should eq ".........."
      end

      it "should handle nil progress" do
        ProgressBarFormatter.format(nil, 10).should eq ".........."
      end
            
      it "should show complete progress" do
        ProgressBarFormatter.format(10, 10).should eq "@@@@@@@@@@"
      end

      it "should show excess progress as complete" do
        ProgressBarFormatter.format(11, 10).should eq "@@@@@@@@@@"
      end

      it "should show partial progress" do
        ProgressBarFormatter.format(5, 10).should eq "@@@@@....."
      end

      it "should round down partial progress" do
        ProgressBarFormatter.format(5, 12).should eq "@@@@......"
      end

      it "should not round down partial progress to zero" do
        ProgressBarFormatter.format(1, 20).should eq "@........."
      end

      context "compressed scale of 5" do
        it "should show partial progress" do
          ProgressBarFormatter.format(5, 10, 5).should eq "@@..."
        end

        it "should show complete progress" do
          ProgressBarFormatter.format(10, 10, 5).should eq "@@@@@"
        end
      end

      context "compressed scale of 2" do
        it "should show partial progress" do
          ProgressBarFormatter.format(5, 10, 2).should eq "@."
        end

        it "should show complete progress" do
          ProgressBarFormatter.format(10, 10, 2).should eq "@@"
        end
      end
      
      context "custom chars" do
        it "should let you override the display" do
          ProgressBarFormatter.format(5, 10, 10, "*", "-").should eq "*****-----"
        end
      end
      
    end
  end
end