require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    
    describe DescCmd do
      include CommandTestHelper
      
      before do
        init_handler(DescCmd, "desc name=description")
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :crack do
        it "should crack a command missing args" do
          init_handler(DescCmd, "desc")
          handler.crack!
          handler.target.should be_nil
          handler.desc.should be_nil
        end

        it "should crack a command missing a desc" do
          init_handler(DescCmd, "desc name")
          handler.crack!
          handler.target.should be_nil
          handler.desc.should be_nil
        end
      
        it "should be able to crack the target - even multi words" do
          init_handler(DescCmd, "desc Bob's Room=new desc")
          handler.crack!
          handler.target.should eq "Bob's Room"
          handler.desc.should eq "new desc"
        end
      
        it "should crack the desc - even with fancy characters" do
          init_handler(DescCmd, "desc Bob=new desc%R%xcTest%xn")
          handler.crack!
          handler.target.should eq "Bob"
          handler.desc.should eq "new desc%R%xcTest%xn"
        end
      end
    end
  end
end