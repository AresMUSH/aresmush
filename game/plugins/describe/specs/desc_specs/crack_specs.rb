require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    
    describe Desc do
      
      describe :crack do
        before do
          @desc = Desc.new
        end        

        it "should crack a command missing a desc" do
          cmd = Command.new(nil, "desc bob")
          @desc.cmd = cmd
          @desc.crack!
          @desc.args.target.should be_nil
          @desc.args.desc.should be_nil
        end
      
        it "should be able to crack the target - even multi words" do
          cmd = Command.new(nil, "desc Bob's Room=new desc")
          @desc.cmd = cmd
          @desc.crack!
          @desc.args.target.should eq "Bob's Room"
        end
      
        it "should crack the desc - even with fancy characters" do
          cmd = Command.new(nil, "desc Bob=new desc%R%xcTest%xn")
          @desc.cmd = cmd
          @desc.crack!
          @desc.args.target.should eq "Bob"
          @desc.args.desc.should eq "new desc%R%xcTest%xn"
        end
      end
    end
  end
end