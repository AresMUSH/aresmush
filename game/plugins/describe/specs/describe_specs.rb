require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
    
    describe DescCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(DescCmd, "describe name=description")
        SpecHelpers.stub_translate_for_testing
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "bob desc set" }        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      
      describe :crack do
        it "should crack a command missing args" do
          init_handler(DescCmd, "describe")
          handler.crack!
          handler.target.should be_nil
          handler.desc.should be_nil
        end

        it "should crack a command missing a desc" do
          init_handler(DescCmd, "describe name")
          handler.crack!
          handler.target.should be_nil
          handler.desc.should be_nil
        end
      
        it "should be able to crack the target - even multi words" do
          init_handler(DescCmd, "describe Bob's Room=new desc")
          handler.crack!
          handler.target.should eq "Bob's Room"
          handler.desc.should eq "new desc"
        end
      
        it "should crack the desc - even with fancy characters" do
          init_handler(DescCmd, "describe Bob=new desc%R%xcTest%xn")
          handler.crack!
          handler.target.should eq "Bob"
          handler.desc.should eq "new desc%R%xcTest%xn"
        end
      end
      
      describe :handle do
        before do
          handler.crack!
        end
        context "success" do
          before do
            @model = double
            @model.stub(:name) { "Bob" }
            find_result = FindResult.new(@model, nil)
            Describe.stub(:can_describe?).with(client, @model) { true }
            VisibleTargetFinder.should_receive(:find).with("name", client) { find_result }
          end
          
          it "should set the desc" do
            client.stub(:emit_success)
            Describe.should_receive(:set_desc).with(@model, "description")
            handler.handle
          end
        
          it "should emit success" do
            Describe.stub(:set_desc)
            client.should_receive(:emit_success).with("bob desc set")
            handler.handle
          end
        end

        context "not allowed" do
          before do
            @model = double
            @model.stub(:name) { "Bob" }
            find_result = FindResult.new(@model, nil)
            Describe.should_receive(:can_describe?).with(client, @model) { false }
            VisibleTargetFinder.should_receive(:find).with("name", client) { find_result }
          end
          
          it "should emit failure" do
            client.should_receive(:emit_failure).with("describe.not_allowed")
            handler.handle
          end
          
          it "should not set the desc" do
            client.stub(:emit_failure)
            Describe.should_not_receive(:set_desc)
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