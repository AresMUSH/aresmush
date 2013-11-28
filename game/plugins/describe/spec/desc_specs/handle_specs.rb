require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Desc do
      before do
        @desc = Desc.new
        @client = double(Client)
        @desc.client = @client
        @args = double
        @desc.stub(:args) { @args }
        @args.stub(:target) { "target" }
        @args.stub(:desc) { "desc" }
        @model = { "name" => "Bob" }
        VisibleTargetFinder.stub(:find) { @model }
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end

      describe :handle do
        it "should set the desc" do
          @client.stub(:emit_success)
          Describe.should_receive(:set_desc).with(@model, "desc")
          @desc.handle
        end
        
        it "should emit success" do
          Describe.stub(:set_desc)
          @client.should_receive(:emit_success).with("desc_set")
          @desc.handle
        end
        
        it "should fail if nothing is found with the name" do
          @desc.stub(:validate) { true }
          VisibleTargetFinder.should_receive(:find).with("target", @client) { nil }
          Describe.should_not_receive(:set_desc)
          @desc.handle
        end       
        
      end
    end
  end
end