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
          allow(Global).to receive(:read_config).with("fs3skills", "luck_for_scene") { {
            '0' => @base_luck,
            '10' => @base_luck * 0.75,
            '25' => @base_luck * 0.5
          } }
        end
        
        it "should give a bonus for RPing with a newbie" do
          newbie = double
          allow(newbie).to receive(:created_at) { Time.now - 86400*2 }
          allow(newbie).to receive(:id) { 111 }
          expect(@scene).to receive(:participants) { [newbie] }
          expect(@char).to receive(:award_luck).with( @base_luck * 3 )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => 1 } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should give a bonus for RPing with someone for the first time" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          expect(@scene).to receive(:participants) { [oldbie] }
          expect(@char).to receive(:award_luck).with( @base_luck * 2 )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => 1 } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should award regular luck if <10 scenes with the person" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          @char.fs3_scene_luck = { 111 => 9 }
          expect(@scene).to receive(:participants) { [oldbie] }
          expect(@char).to receive(:award_luck).with( @base_luck )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => 10 } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should reduce luck if more than 10 scenes" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          @char.fs3_scene_luck = { 111 => 11 }
          expect(@scene).to receive(:participants) { [oldbie] }
          expect(@char).to receive(:award_luck).with( @base_luck * 0.75 )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => 12 } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should reduce luck if more than 25 scenes" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          @char.fs3_scene_luck = { 111 => 26 }
          expect(@scene).to receive(:participants) { [oldbie] }
          expect(@char).to receive(:award_luck).with( @base_luck * 0.5 )
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => 27 } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should tally up luck for all participants" do
          oldbie = double
          newbie = double
          allow(newbie).to receive(:created_at) { Time.now - 86400*2 }
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          allow(newbie).to receive(:id) { 333 }
          @char.fs3_scene_luck = { 111 => 15 }
          expect(@scene).to receive(:participants) { [oldbie, newbie] }
          expect(@char).to receive(:award_luck).with(@base_luck * 0.75 + @base_luck * 3)
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => 16, 333 => 1 } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
        
        it "should not give luck for yourself" do
          oldbie = double
          allow(oldbie).to receive(:created_at) { Time.now - 86400*90 }
          allow(oldbie).to receive(:id) { 111 }
          expect(@scene).to receive(:participants) { [oldbie, @char] }
          expect(@char).to receive(:award_luck).with(@base_luck * 2)
          expect(@char).to receive(:update).with( { :fs3_scene_luck => { 111 => 1 } } )
          FS3Skills.luck_for_scene(@char, @scene)
        end
      end
    end
  end
end
