require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @connect = Connect.new
        @cmd = double
        @client = double
        @connect.cmd = @cmd
        @connect.client = @client
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :validate do
        context "logged in" do
          it "should fail if already logged in" do
            @client.stub(:logged_in?) { true }
            @connect.validate.should eq "login.already_logged_in"
          end
        end
      
        context "not logged in" do
          before do
            @client.stub(:logged_in?) { false }
          end
        
          it "should fail if no name provided" do
            @connect.stub(:args) { HashReader.new( { "name" => nil, "password" => "foo" })}
            @connect.validate.should eq "login.invalid_connect_syntax"
          end

          it "should fail if no password provided" do
            @connect.stub(:args) { HashReader.new( { "name" => "Bob", "password" => nil })}
            @connect.validate.should eq "login.invalid_connect_syntax"
          end
        
          it "should pass if arguments are valid" do
            @connect.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "foo" })}
            @connect.validate.should be_nil          
          end  
        end      
      end          
    end
  end
end