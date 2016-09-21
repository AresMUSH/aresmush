module AresMUSH
  module FS3Luck
    describe Api do

      before do
        Global.stub(:read_config).with("fs3luck", "max_luck") { 3 }
      end
      
      describe :award_luck do
        before do
          @char = Character.new(luck: 1)
        end
        
        it "should add luck" do
          FS3Luck::Api.award_luck(@char, 1)
          @char.luck.should eq 2
        end

        it "should not go over the cap" do
          FS3Luck::Api.award_luck(@char, 5)
          @char.luck.should eq 3
        end
      end
      
      describe :spend_luck do
        before do
          @char = Character.new(luck: 2)
        end
        
        it "should spend luck" do
          FS3Luck::Api.spend_luck(@char, 1)
          @char.luck.should eq 1
        end

        it "should not go below zero" do
          FS3Luck::Api.spend_luck(@char, 5)
          @char.luck.should eq 0
        end
      end
      
      
      describe :luck do
        before do
          @char = Character.new(luck: 2)
        end
        
        it "should return luck" do
          FS3Luck::Api.luck(@char).should eq 2
        end
      end
    end
  end
end
