module AresMUSH
  module FS3Skills
    describe FS3Skills do
      describe :can_parse_roll_params do
        it "should handle attribute by itself" do
          params = FS3Skills.parse_roll_params("A")
          check_params(params, "A", 0, nil)
        end
        
        it "should handle abiliity and positive modifier" do
          params = FS3Skills.parse_roll_params("A+22")
          check_params(params, "A", 22, nil)
        end

        it "should handle abiliity and positive modifier" do
          params = FS3Skills.parse_roll_params("A+22")
          check_params(params, "A", 22, nil)
        end

        it "should handle abiliity and negative modifier" do
          params = FS3Skills.parse_roll_params("A-3")
          check_params(params, "A", -3, nil)
        end
        
        it "should handle ability with space" do
          params = FS3Skills.parse_roll_params("A B")
          check_params(params, "A B", 0, nil)
        end
        
        it "should handle ability with modifier and space" do
          params = FS3Skills.parse_roll_params("A B + 3")
          check_params(params, "A B", 3, nil)
        end

        it "should handle ability with modifier and ruling attr and space" do
          params = FS3Skills.parse_roll_params("A B + C D + 3")
          check_params(params, "A B", 3, "C D")
        end
        
        it "should handle ability and ruling attr" do
          params = FS3Skills.parse_roll_params("A+B")
          check_params(params, "A", 0, "B")
        end

        it "should handle ability and ruling attr and modifier" do
          params = FS3Skills.parse_roll_params("A+B-2")
          check_params(params, "A", -2, "B")
        end
        
        it "should handle bad string with negative ruling attr" do
          params = FS3Skills.parse_roll_params("A-B+2")
          params.should be_nil
        end

        it "should handle bad string with a non-digit modifier" do
          params = FS3Skills.parse_roll_params("A+B+C")
          params.should be_nil
        end
        
        it "should handle bad string with too many params" do
          params = FS3Skills.parse_roll_params("A+B+2+D")
          params.should be_nil
        end
      end
      
      def check_params(params, ability, modifier, ruling_attr)
        params[:ability].should eq ability
        params[:modifier].should eq modifier
        params[:ruling_attr].should eq ruling_attr
      end
    end
  end
end