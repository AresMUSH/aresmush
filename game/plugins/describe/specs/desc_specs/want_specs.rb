require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    describe Desc do
      before do
        @desc = Desc.new
        @client = double(Client).as_null_object
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end
      
      describe :want_command? do
        it "wants the desc command" do
          cmd = double
          cmd.stub(:root_is?).with("desc") { true }
          @desc.want_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = double
          cmd.stub(:root_is?).with("desc") { false }
          cmd.stub(:logged_in?) { true }
          @desc.want_command?(cmd).should be_false
        end
      end            
   end     
  end
end