require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe HideCmd do
      include CommandTestHelper
      
      before do
        init_handler(HideCmd, "hide")
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :want_command do
        it "should want the hide command" do
          handler.want_command?(client, cmd).should be_true
        end

        it "should not want another command" do
          cmd.stub(:root_is?).with("hide") { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
      
      describe :validate do
        it "should reject the command if there are args" do
          cmd.stub(:root_only?) { false }
          client.stub(:logged_in?) { true }
          handler.validate.should eq 'who.invalid_hide_syntax'
        end
        
        it "should reject the command if not logged in" do
          client.stub(:logged_in?) { false }            
          handler.validate.should eq 'dispatcher.must_be_logged_in'
        end
        
        it "should accept the command otherwise" do
          client.stub(:logged_in?) { true }
          handler.validate.should be_nil 
        end
      end

      describe :handle do
        it "should toggle the hidden flag on" do
          char.should_receive(:hidden) { false }
          char.should_receive(:hidden=).with(true)
          client.should_receive(:emit_success).with('who.hide_enabled')
          handler.handle
        end
        
        it "should toggle the hidden flag off" do
          char.should_receive(:hidden) { true }
          char.should_receive(:hidden=).with(false)
          client.should_receive(:emit_success).with('who.hide_disabled')
          handler.handle
        end
      end
    end
  end
end