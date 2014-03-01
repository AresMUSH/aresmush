require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe LookCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(LookCmd, "look something")
        handler.crack!
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :handle do
        context "target found" do
          before do
            @model = double
            VisibleTargetFinder.stub(:find) { FindResult.new(@model, nil)}
            client.stub(:emit)
            Describe.stub(:get_desc) { "a desc" }
          end

          it "should find a visible target in the looker's room" do
            VisibleTargetFinder.should_receive(:find).with("something", client) { FindResult.new(@model, nil)}
            handler.handle
          end
          
          it "should get the desc from the interface" do          
            Describe.should_receive(:get_desc).with(@model) { "a desc" }
            handler.handle
          end
        
          it "should emit the desc to the client" do
            client.should_receive(:emit).with("a desc")
            handler.handle
          end    
        end
        
        context "target not found" do
          before do
            VisibleTargetFinder.stub(:find) { FindResult.new(nil, "an error") }
          end
          
          it "should emit the error to the client" do
            client.should_receive(:emit_failure).with("an error")
            handler.handle
          end
          
          it "should not emit the desc" do
            client.should_not_receive(:emit)
            client.stub(:emit_failure)
            handler.handle
          end
        end
      end
    end
  end
end