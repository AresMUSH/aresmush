module AresMUSH
  module Api
    describe ApiCommand do
      describe :create_from do
        
        it "should create from a command string" do
          response = ApiCommand.create_from("test arg1 arg2")
          response.command_name.should eq "test"
          response.args_str.should eq "arg1 arg2"
        end
      
        it "should create from a command string without args" do
          response = ApiCommand.create_from("test")
          response.command_name.should eq "test"
          response.args_str.should eq ""
        end
      
        it "should raise an error if the format is wrong" do
          expect { response = ApiCommand.create_from("") }.to raise_error
        end
      end
      
      describe :to_s do
        it "should build the command string" do
          response = ApiCommand.create_from("test arg1 arg2")
          response.to_s.should eq "test arg1 arg2"
        end
      
        it "should build the command string if no args" do
          response = ApiCommand.create_from("test")
          response.to_s.should eq "test"
        end
      end
    end
  end
end