module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        allow(Global).to receive(:read_config).with("fs3skills", "max_luck") { 3 }
      end
      
      describe :award_luck do
        before do
          @char = Character.new(fs3_luck: 1)
        end
        
        it "should add luck" do
          expect(@char).to receive(:update).with(fs3_luck: 2.0) {}
          @char.award_luck(1)
        end

        it "should not go over the cap" do
          expect(@char).to receive(:update).with(fs3_luck: 3.0) {}
          @char.award_luck(5)
        end
      end
      
      describe :spend_luck do
        before do
          @char = Character.new(fs3_luck: 2)
        end
        
        it "should spend luck" do
          expect(@char).to receive(:update).with(fs3_luck: 1.0)
          @char.spend_luck(1)
        end

        it "should not go below zero" do
          expect(@char).to receive(:update).with(fs3_luck: 0)
          @char.spend_luck(5)
        end
      end
      
      
      describe :luck do
        before do
          @char = Character.new(fs3_luck: 2)
        end
        
        it "should return luck" do
          expect(@char.luck).to eq 2
        end
      end
    end
  end
end
