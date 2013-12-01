require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe Create do
      before do
        @create = Create.new
        @cmd = double
        @create.cmd = @cmd
        @cmd.stub(:logged_in?) { false }
        Login.stub(:validate_char_name) { nil }
        Login.stub(:validate_char_password) { nil }        
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :validate do
        it "should fail if already logged in" do
          @cmd.stub(:logged_in?) { true }
          @create.validate.should eq "dispatcher.already_logged_in"
        end
        
        it "should fail if the name is missing" do
          @create.stub(:args) { HashReader.new( { "name" => nil, "password" => "passwd" })}
          @create.validate.should eq "login.invalid_create_syntax"
        end

        it "should fail if the password is missing" do
          @create.stub(:args) { HashReader.new( { "name" => "name", "password" => nil })}
          @create.validate.should eq "login.invalid_create_syntax"
        end

        it "should fail if the name is invalid" do
          @create.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "passwd" })}
          Login.should_receive(:validate_char_name).with("Bob") { "invalid name"}
          @create.validate.should eq "invalid name"          
        end
        
        it "should fail if the password is invalid" do
          @create.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "passwd" })}
          Login.should_receive(:validate_char_password).with("passwd") { "invalid password"}
          @create.validate.should eq "invalid password"          
        end
        
        it "should pass if everything's oK" do
          @create.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "passwd" })}
          @create.validate.should be_nil
        end
        
      end
    end
  end
end

