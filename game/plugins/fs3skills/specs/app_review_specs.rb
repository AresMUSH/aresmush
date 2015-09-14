module AresMUSH
  module FS3Skills
    describe FS3Skills do 
      
      before do
        Global.stub(:read_config).with("fs3skills", "free_languages") { 2 }
        Global.stub(:read_config).with("fs3skills", "free_interests") { 3 }
        @char = double
      end
      
      describe :points_on_rated_abilities do
        it "should charge 1 point each for advantages and action skills" do
          @char.stub(:fs3_action_skills) { { "Firearms" => 2, "Alertness" => 3}}
          @char.stub(:fs3_advantages) { { "Wealth" => 1 } }
          FS3Skills.points_on_rated_abilities(@char).should eq 6
        end
      end
      
      describe :points_on_interests do
        it "should allow some interests for free" do
          @char.stub(:fs3_interests) { ["A", "B", "C"]}
          FS3Skills.points_on_interests(@char).should eq 0
        end

        it "should charge 1 point each for excessive interests" do
          @char.stub(:fs3_interests) { ["A", "B", "C", "D", "E"]}
          FS3Skills.points_on_interests(@char).should eq 2
        end
      end    
      
      describe :points_on_languages do
        it "should allow some languages for free" do
          @char.stub(:fs3_languages) { ["A", "B"]}
          FS3Skills.points_on_languages(@char).should eq 0
        end

        it "should charge 1 point each for excessive languages" do
          @char.stub(:fs3_languages) { ["A", "B", "C"]}
          FS3Skills.points_on_languages(@char).should eq 1
        end
      end
      
      describe :points_on_expertise do
        it "should charge 2 points each for expertise" do
          @char.stub(:fs3_expertise) { ["A", "B", "C"] }
          FS3Skills.points_on_expertise(@char).should eq 6
        end
      end
      
      describe :total_points do 
        it "should count ratings interests languages and experience" do
          @char.stub(:fs3_action_skills) { { "Firearms" => 2, "Alertness" => 3}}
          @char.stub(:fs3_advantages) { { "Wealth" => 1 } }
          @char.stub(:fs3_interests) { ["A", "B", "C", "D", "E"]}
          @char.stub(:fs3_languages) { ["A", "B", "C"]}
          @char.stub(:fs3_expertise) { ["A", "B", "C"] }
          FS3Skills.points_total(@char).should eq 15
        end
      end
    end
  end
end