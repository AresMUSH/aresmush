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
      
      describe :luck_for_scene do
        before do
          @char = Character.new(fs3_luck: 2, fs3_scene_luck: {})
          @scene = double
          @base_luck = 0.1
          allow(Global).to receive(:read_config).with("fs3skills", "base_luck_for_scene") { @base_luck }
        end
        
        it "should give a bonus for RPing with a newbie" do
          newbie = double
          allow(newbie).to receive(:created_at) { Time.now - 86400*2 }
          allow(newbie).to receive(:id) { 111 }
          expect(@scene).to receive(:participants) { [newbie] }
          expect(@scene).to receive(:id) { 222 }
          expect(@char).to receive(:award_luck).with( @base_luck * 3 )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => [ 222 ] } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should give a bonus for RPing with someone for the first time" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          expect(@scene).to receive(:participants) { [oldbie] }
          expect(@scene).to receive(:id) { 222 }
          expect(@char).to receive(:award_luck).with( @base_luck * 2 )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => [ 222 ] } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should award regular luck if <10 scenes with the person" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          @char.fs3_scene_luck = { 111 => [ 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009 ] }
          expect(@scene).to receive(:participants) { [oldbie] }
          expect(@scene).to receive(:id) { 222 }.twice
          expect(@char).to receive(:award_luck).with( @base_luck )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => [ 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 222 ] } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should reduce luck if more than 10 scenes" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          @char.fs3_scene_luck = { 111 => [ 123, 456, 789, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008 ] }
          expect(@scene).to receive(:participants) { [oldbie] }
          expect(@scene).to receive(:id) { 222 }.twice
          expect(@char).to receive(:award_luck).with( @base_luck / 2 )
          expect(@char).to receive(:update)
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should tally up all participant luck" do
          oldbie = double
          newbie = double
          allow(newbie).to receive(:created_at) { Time.now - 86400*2 }
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          allow(newbie).to receive(:id) { 333 }
          expect(@scene).to receive(:participants) { [oldbie, newbie] }
          expect(@scene).to receive(:id) { 222 }.twice
          expect(@char).to receive(:award_luck).with(@base_luck * 2 + @base_luck * 3)
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => [ 222 ], 333 => [ 222 ] } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
      end
    end
  end
end
