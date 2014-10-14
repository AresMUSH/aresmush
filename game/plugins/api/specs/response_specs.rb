require_relative "../../plugin_test_loader"

module AresMUSH
  module Api
    class TestFooApiResponse < ApiResponse
      attr_accessor :foo, :bar
      def initialize(command_name, foo, bar)
        @foo = foo
        @bar = bar
        super(command_name, ApiResponse.ok_status, "#{foo} #{bar}")
      end
    end
    
    describe ApiResponse do
      describe :create_from do
        
        it "should create from a response string" do
          response = ApiResponse.create_from("test OK arg1 arg2")
          response.command_name.should eq "test"
          response.status.should eq "OK"
          response.args_str.should eq "arg1 arg2"
        end
      
        it "should create from a response string without args" do
          response = ApiResponse.create_from("test OK")
          response.command_name.should eq "test"
          response.status.should eq "OK"
          response.args_str.should eq ""
        end
      
        it "should raise an error if the format is wrong" do
          expect { response = ApiResponse.create_from("test") }.to raise_error
        end
      end
      
      describe :to_s do
        it "should build the response string" do
          response = ApiResponse.create_from("test OK arg1 arg2")
          response.to_s.should eq "test OK arg1 arg2"
        end
      
        it "should build the response string if no args" do
          response = ApiResponse.create_from("test OK arg1")
          response.to_s.should eq "test OK arg1"
        end
      end
    end
  end
end