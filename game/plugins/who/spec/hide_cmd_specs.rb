require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe HideCmd do
      include MockClient

      describe :want_command do
        before do
          @hide = HideCmd.new
          @cmd = double
        end
        
        it "should want the hide command from a logged in player" do
          @cmd.stub(:root_is?).with("hide") { true }
          @cmd.stub(:logged_in?) { true }
          @hide.want_command?(@cmd).should be_true
        end

        it "should not want the hide command from a player who isn't logged in" do
          @cmd.stub(:root_is?).with("hide") { true }
          @cmd.stub(:logged_in?) { false }
          @hide.want_command?(@cmd).should be_false
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("hide") { false }
          @cmd.stub(:logged_in?) { true }
          @hide.want_command?(@cmd).should be_false
        end
      end

      describe :on_command do        
        before do
          @mock_client = build_mock_client
          @hide = HideCmd.new
          SpecHelpers.stub_translate_for_testing
        end

        it "should toggle the hidden flag on" do
          @mock_client[:char].should_receive(:hidden) { false }
          @mock_client[:char].should_receive(:hidden=).with(true)
          @mock_client[:client].should_receive(:emit_success).with('who.hide_enabled')
          @hide.on_command(@mock_client[:client], nil)
        end
        
        it "should toggle the hidden flag off" do
          @mock_client[:char].should_receive(:hidden) { true }
          @mock_client[:char].should_receive(:hidden=).with(false)
          @mock_client[:client].should_receive(:emit_success).with('who.hide_disabled')
          @hide.on_command(@mock_client[:client], nil)
        end
      end
    end
  end
end