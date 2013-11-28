require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    
    describe Desc do
      
      describe :crack do
        before do
          @desc = Desc.new
        end

        it "should return nil for args that are missing" do
          cmd = Command.new(@client, "desc bob")
          args = @desc.crack(cmd)
          args.target.should be_nil
          args.desc.should be_nil
        end
      
        it "should be able to crack the target - even multi words" do
          cmd = Command.new(@client, "desc Bob's Room=new desc")
          args = @desc.crack(cmd)
          args.target.should eq "Bob's Room"
        end
      
        it "should crack the desc - even with fancy characters" do
          cmd = Command.new(@client, "desc Bob=new desc%R%xcTest%xn")
          args = @desc.crack(cmd)
          args.target.should eq "Bob"
          args.desc.should eq "new desc%R%xcTest%xn"
        end
      end
    end
  end
end