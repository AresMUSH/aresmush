require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe LookCmdCracker do
      
      describe :crack do
        it "should crack the target" do
          cmd = Command.new(@client, "look Bob's Room")
          args = LookCmdCracker.crack(cmd)
          args.target.should eq "Bob's Room"
        end
        
        it "should handle a missing target" do
          cmd = Command.new(@client, "look")
          args = LookCmdCracker.crack(cmd)
          args.should eq nil
        end        
      end
    end
  end
end