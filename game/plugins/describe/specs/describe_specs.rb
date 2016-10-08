require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
    
    describe DescCmd do
      include CommandHandlerTestHelper
      
      before do
        init_handler(DescCmd, "describe name=description")
        SpecHelpers.stub_translate_for_testing
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "bob desc set" }        
      end
      
      it_behaves_like "a plugin that requires login"
            
      describe :crack do
        it "should crack a command missing args" do
          init_handler(DescCmd, "describe")
          handler.crack!
          handler.target.should be_nil
          handler.description.should be_nil
        end

        it "should crack a command missing a desc" do
          init_handler(DescCmd, "describe name")
          handler.crack!
          handler.target.should be_nil
          handler.description.should be_nil
        end
      
        it "should be able to crack the target - even multi words" do
          init_handler(DescCmd, "describe Bob's Room=new desc")
          handler.crack!
          handler.target.should eq "Bob's Room"
          handler.description.should eq "new desc"
        end
      
        it "should crack the desc - even with fancy characters" do
          init_handler(DescCmd, "describe Bob=new desc%R%xcTest%xn")
          handler.crack!
          handler.target.should eq "Bob"
          handler.description.should eq "new desc%R%xcTest%xn"
        end
      end   
    end
  end
end