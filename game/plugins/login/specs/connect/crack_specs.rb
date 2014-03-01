require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe ConnectCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(ConnectCmd, "connect Bob bobpassword")
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :crack do
        it "should crack the arguments" do
          init_handler(ConnectCmd, "connect Bob password")
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "password"
        end
        
        it "should handle no args" do
          init_handler(ConnectCmd, "connect")
          handler.cmd = cmd
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end
        
        it "should handle a missing password" do
          init_handler(ConnectCmd, "connect Bob")
          handler.cmd = cmd
          handler.crack!
          handler.charname.should be_nil
          handler.password.should be_nil
        end

        it "should accept a multi-word password" do
          init_handler(ConnectCmd, "connect Bob bob's password")
          handler.cmd = cmd
          handler.crack!
          handler.charname.should eq "Bob"
          handler.password.should eq "bob's password"
        end        
      end      
    end
  end
end