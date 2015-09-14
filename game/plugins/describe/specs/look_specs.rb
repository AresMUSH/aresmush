require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe LookCmd do
      include PluginCmdTestHelper
      include GlobalTestHelper
      
      before do
        init_handler(LookCmd, "look something")
        SpecHelpers.stub_translate_for_testing        
        stub_global_objects
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "look" }
      end
      
      describe :crack do
        it "should set the target" do
          init_handler(LookCmd, "look Bob's Room")
          handler.crack!
          handler.target.should eq "Bob's Room"
        end
        
        it "should use here if there's no target" do
          init_handler(LookCmd, "look")
          handler.crack!
          handler.target.should eq "here"
        end
      end
      
      describe :handle do
        before do
          handler.crack!
        end
        
        context "target found" do
          before do
            @model = double
            @template = double
            VisibleTargetFinder.stub(:find) { FindResult.new(@model, nil)}
            Describe.stub(:get_desc_template) { @template }
            @template.stub(:render)
          end

          it "should find a visible target in the looker's room" do
            VisibleTargetFinder.should_receive(:find).with("something", client) { FindResult.new(@model, nil)}
            handler.handle
          end
          
          it "should get the desc from the interface" do          
            Describe.should_receive(:get_desc_template).with(@model, client) { @template }
            handler.handle
          end
        
          it "should emit the desc to the client" do
            @template.should_receive(:render)
            handler.handle
          end  
          
          it "should tell them they're being looked at" do
            @model = Character.new
            client.stub(:name) { "Bob" }
            other_client = double
            @model.should_receive(:client) { other_client }
            other_client.should_receive(:emit_ooc).with('describe.looked_at_you')
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