require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe CreateCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(CreateCmd, "create Bob bobpassword")
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :crack! do
        it "should be able to crack correct args" do
          init_handler(CreateCmd, "create Bob foo")
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "foo"
        end

        it "should be able to crack if args are missing" do
          init_handler(CreateCmd, "create")
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end
        
        it "should be able to crack a multi-word password" do
          init_handler(CreateCmd, "create Bob bob's passwd")
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "bob's passwd"
        end
        
        it "should be able to crack a missing password" do
          init_handler(CreateCmd, "create Bob")
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end
      end
    end
  end
end

