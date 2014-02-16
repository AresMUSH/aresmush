require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Desc do
      before do
        @desc = Desc.new
        @client = double(Client)
        @desc.client = @client
        @desc.stub(:args) { HashReader.new( { "target" => "Bob", "desc" => "My desc" } ) }
        @model = { "name" => "Bob" }
        find_result = FindResult.new(@model, nil)
        VisibleTargetFinder.stub(:find) { find_result }
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end

      describe :handle do
        it "should set the desc" do
          @client.stub(:emit_success)
          Describe.should_receive(:set_desc).with(@model, "My desc")
          @desc.handle
        end
        
        it "should emit success" do
          Describe.stub(:set_desc)
          @client.should_receive(:emit_success).with("desc_set")
          @desc.handle
        end
        
        it "should fail if nothing is found with the name" do
          @desc.stub(:validate) { true }
          find_result = FindResult.new(nil, "Not found")
          VisibleTargetFinder.should_receive(:find).with("Bob", @client) { find_result }
          @client.should_receive(:emit_failure).with("Not found")
          Describe.should_not_receive(:set_desc)
          @desc.handle
        end       
        
      end
    end
  end
end