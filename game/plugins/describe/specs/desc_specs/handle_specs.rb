require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    describe DescCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(DescCmd, "desc name=description")
        handler.crack!
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }        
      end  

      describe :handle do
        context "success" do
          before do
            @model = double
            @model.stub(:name) { "Bob" }
            find_result = FindResult.new(@model, nil)
            VisibleTargetFinder.should_receive(:find).with("name", client) { find_result }
          end
          
          it "should set the desc" do
            client.stub(:emit_success)
            Describe.should_receive(:set_desc).with(@model, "description")
            handler.handle
          end
        
          it "should emit success" do
            Describe.stub(:set_desc)
            client.should_receive(:emit_success).with("desc_set")
            handler.handle
          end
        end
      
        context "nothing found" do        
          before do
            find_result = FindResult.new(nil, "Not found")
            VisibleTargetFinder.should_receive(:find).with("name", client) { find_result }
          end
          
          it "should emit failure" do
            client.should_receive(:emit_failure).with("Not found")
            handler.handle
          end
          
          it "should not set the desc" do
            client.stub(:emit_failure)
            Describe.should_not_receive(:set_desc)
            handler.handle
          end
        end
      end
    end
  end
end