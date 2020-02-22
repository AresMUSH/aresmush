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
      
      describe :require_text do
        it "should OK some text" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => '' } }
          @validator = ConfigValidator.new("foo")
          @validator.require_text("some_val")
          expect(@validator.errors).to eq []
        end

        it "should fail for an invalid type" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 123 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_text("some_val")
          expect(@validator.errors).to eq ["foo:some_val must be a text string."]
        end

        it "should fail if value is not there" do 
          expect(Global).to receive(:read_config).with("foo") { {} }
          @validator = ConfigValidator.new("foo")
          @validator.require_text("some_val")
          expect(@validator.errors).to eq ["foo:some_val must be a text string."]
        end
      end
      
      describe :require_nonblank_text do
        it "should OK some text" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 'xxx' } }
          @validator = ConfigValidator.new("foo")
          @validator.require_nonblank_text("some_val")
          expect(@validator.errors).to eq []
        end

        it "should fail for an invalid type" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 123 } }
          @validator = ConfigValidator.new("foo")
          @validator.require_nonblank_text("some_val")
          expect(@validator.errors).to eq ["foo:some_val must be a non-blank text string."]
        end

        it "should fail if value is not there" do 
          expect(Global).to receive(:read_config).with("foo") { {} }
          @validator = ConfigValidator.new("foo")
          @validator.require_nonblank_text("some_val")
          expect(@validator.errors).to eq ["foo:some_val must be a non-blank text string."]
        end
        
        it "should fail if string is blank" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => '' } }
          @validator = ConfigValidator.new("foo")
          @validator.require_nonblank_text("some_val")
          expect(@validator.errors).to eq ["foo:some_val must be a non-blank text string."]
        end
      end
      
      
      describe :require_boolean do
        it "should OK true" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => true } }
          @validator = ConfigValidator.new("foo")
          @validator.require_boolean("some_val")
          expect(@validator.errors).to eq []
        end

        it "should OK false" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => false } }
          @validator = ConfigValidator.new("foo")
          @validator.require_boolean("some_val")
          expect(@validator.errors).to eq []
        end

        it "should fail for an invalid type" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 'true' } }
          @validator = ConfigValidator.new("foo")
          @validator.require_boolean("some_val")
          expect(@validator.errors).to eq ["foo:some_val must be true or false (without quotes)."]
        end

        it "should fail if value is not there" do 
          expect(Global).to receive(:read_config).with("foo") { {} }
          @validator = ConfigValidator.new("foo")
          @validator.require_boolean("some_val")
          expect(@validator.errors).to eq ["foo:some_val must be true or false (without quotes)."]
        end
      end
      
      
      describe :check_cron do
        it "should OK true" do 
          cron = { 
            'hour' => [ 1, 2 ],
            'day_of_week' => [ 'Tue', 'Wed' ]
          }
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => cron } }
          @validator = ConfigValidator.new("foo")
          @validator.check_cron("some_val")
          expect(@validator.errors).to eq []
        end

        it "should fail if cron specs not a list" do 
          cron = { 
            'hour' => 1,
            'day_of_week' => [ 'Tue', 'Wed' ]
          }
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => cron } }
          @validator = ConfigValidator.new("foo")
          @validator.check_cron("some_val")
          expect(@validator.errors).to eq ["foo:some_val - hour is not a list."]
        end

        it "should fail if not a hash" do 
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => 123 } }
          @validator = ConfigValidator.new("foo")
          @validator.check_cron("some_val")
          expect(@validator.errors).to eq ["foo:some_val is not a hash."]
        end

        it "should fail if invalid hash setting" do 
          cron = { 
            'hour' => [ 1, 2 ],
            'day' => [ 'Tue', 'Wed' ]
          }
          expect(Global).to receive(:read_config).with("foo") { { "some_val" => cron } }
          @validator = ConfigValidator.new("foo")
          @validator.check_cron("some_val")
          expect(@validator.errors).to eq ["foo:some_val - day is not a valid setting."]
        end
      end
    end
  end
end
