module AresMUSH
  module Manage
    describe ConfigValidator do
      
      describe :require_hash do
        it "should OK a hash" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => {} } }
          @validator = ConfigValidator.new("foo")
          @validator.require_hash("some_val")
          expect(@validator.errors).to eq []
        end

        it "should fail for an invalid type" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 123 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_hash("some_val")
          expect(@validator.errors).to eq ["foo:some_val is not a hash."]
        end

        it "should fail if value is not there" do 
          expect(Global).to receive(:read_config).with("foo") { {} }
          @validator = ConfigValidator.new("foo")
          @validator.require_hash("some_val")
          expect(@validator.errors).to eq ["foo:some_val is not a hash."]
        end
      end
      
      describe :require_list do
        it "should OK a list" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => [] } }
          @validator = ConfigValidator.new("foo")
          @validator.require_list("some_val")
          expect(@validator.errors).to eq []
        end

        it "should fail for an invalid type" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 123 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_list("some_val")
          expect(@validator.errors).to eq ["foo:some_val is not a list/array."]
        end

        it "should fail if value is not there" do 
          expect(Global).to receive(:read_config).with("foo") { {} }
          @validator = ConfigValidator.new("foo")
          @validator.require_list("some_val")
          expect(@validator.errors).to eq ["foo:some_val is not a list/array."]
        end
      end
      
      describe :require_in_list do
        it "should OK an item in the list" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 'AAA' } }
          @validator = ConfigValidator.new("foo")
          @validator.require_in_list("some_val", [ 'BBB', 'AAA' ])
          expect(@validator.errors).to eq []
        end

        it "should fail for an invalid type" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 123 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_in_list("some_val", [ 'BBB', 'AAA' ])
          expect(@validator.errors).to eq ["foo:some_val must be one of: BBB, AAA."]
        end

        it "should fail if value is not there" do 
          expect(Global).to receive(:read_config).with("foo") { {} }
          @validator = ConfigValidator.new("foo")
          @validator.require_in_list("some_val", [ 'BBB', 'AAA' ])
          expect(@validator.errors).to eq ["foo:some_val must be one of: BBB, AAA."]
        end
        
        it "should fail if value is not in list" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => [ 'CCC' ] } }
          @validator = ConfigValidator.new("foo")
          @validator.require_in_list("some_val", [ 'BBB', 'AAA' ])
          expect(@validator.errors).to eq ["foo:some_val must be one of: BBB, AAA."]
        end
      end
      
      describe :require_int do
        it "should OK an int" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 123 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_int("some_val")
          expect(@validator.errors).to eq []
        end

        it "should fail for an invalid type" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => '123' } }
          @validator = ConfigValidator.new("foo")
          @validator.require_int("some_val")
          expect(@validator.errors).to eq ["foo:some_val is not a whole number."]
        end

        it "should fail if value is not there" do 
          expect(Global).to receive(:read_config).with("foo") { {} }
          @validator = ConfigValidator.new("foo")
          @validator.require_int("some_val")
          expect(@validator.errors).to eq ["foo:some_val is not a whole number."]
        end
        
        it "should not care if value is too small if no min specified" do
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => -123 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_int("some_val")
          expect(@validator.errors).to eq []
        end
        
        it "should not care if value is too small if no max specified" do
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 99999 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_int("some_val")
          expect(@validator.errors).to eq []
        end
        
        it "should fail if value smaller than min" do
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 4 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_int("some_val", 5)
          expect(@validator.errors).to eq [ "foo:some_val must be at least 5." ]
        end
        
        it "should not care if value is too small if no max specified" do
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 51 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_int("some_val", 5, 50)
          expect(@validator.errors).to eq [ "foo:some_val must not be more than 50." ]
        end
        
      end
      
    end
  end
end
