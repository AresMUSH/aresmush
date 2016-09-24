module AresMUSH
  module FS3Skills
    describe Api do

      before do
        Global.stub(:read_config).with("fs3skills", "max_luck") { 3 }
      end
      
      describe :award_luck do
        before do
          @char = Character.new(luck: 1)
        end
        
        it "should add luck" do
          FS3Skills::Api.award_luck(@char, 1)
          @char.luck.should eq 2
        end

        it "should not go over the cap" do
          FS3Skills::Api.award_luck(@char, 5)
          @char.luck.should eq 3
        end
      end
      
      describe :spend_luck do
        before do
          @char = Character.new(luck: 2)
        end
        
        it "should spend luck" do
          FS3Skills::Api.spend_luck(@char, 1)
          @char.luck.should eq 1
        end

        it "should not go below zero" do
          FS3Skills::Api.spend_luck(@char, 5)
          @char.luck.should eq 0
        end
      end
      
      
      describe :luck do
        before do
          @char = Character.new(luck: 2)
        end
        
        it "should return luck" do
          FS3Skills::Api.luck(@char).should eq 2
        end
      end
    end
  end
end
