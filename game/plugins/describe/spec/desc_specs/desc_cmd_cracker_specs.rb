require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe DescCmdCracker do
      it "should return nil if args are missing" do
        cmd = Command.new(@client, "desc bob")
        args = DescCmdCracker.crack(cmd)
        args.should eq nil
      end
      
      it "should be able to crack the target - even multi words" do
        cmd = Command.new(@client, "desc Bob's Room=new desc")
        args = DescCmdCracker.crack(cmd)
        args.target.should eq "Bob's Room"
      end
      
      it "should crack the desc - even with fancy characters" do
        cmd = Command.new(@client, "desc Bob=new desc%R%xcTest%xn")
        args = DescCmdCracker.crack(cmd)
        args.target.should eq "Bob"
        args.desc.should eq "new desc%R%xcTest%xn"
      end
    end

  end
end