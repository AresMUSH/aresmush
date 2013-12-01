require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Look do
      
      describe :crack do
        
        before do
          @look = Look.new
        end
        
        it "should crack the target" do
          cmd = Command.new(@client, "look Bob's Room")
          @look.cmd = cmd
          @look.crack!
          cmd.args.target.should eq "Bob's Room"
        end
        
        it "should handle a missing target" do
          cmd = Command.new(@client, "look")
          @look.cmd = cmd
          @look.crack!
          cmd.args.target.should be_nil
        end        
      end
    end
  end
end