require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe DescCmdHandler do
      before do
        @model = { "name" => "Bob" }
        @client = double(Client)
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end

      describe :handle do
        it "should set the desc" do
          @client.stub(:emit_success)
          Describe.should_receive(:set_desc).with(@model, "My desc")
          DescCmdHandler.handle(@model, "My desc", @client)
        end
        
        it "should emit success" do
          Describe.stub(:set_desc)
          @client.should_receive(:emit_success).with("desc_set")
          DescCmdHandler.handle(@model, "My desc", @client)
        end
      end
    end
  end
end