module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        Global.stub(:read_config).with("fs3skills", "max_xp_hoard") { 3 }
      end
      
      describe :award_xp do
        before do
          @char = Character.new(fs3_xp: 1)
        end
        
        it "should add xp" do
          @char.should_receive(:update).with(fs3_xp: 2)
          @char.award_xp(1)
        end

        it "should not go over the cap" do
          @char.should_receive(:update).with(fs3_xp: 3)
          @char.award_xp(5)
        end
      end
      
      describe :xp do
        before do
          @char = Character.new(fs3_xp: 2)
        end
        
        it "should return xp" do
          @char.xp.should eq 2
        end
      end
    end
  end
end
