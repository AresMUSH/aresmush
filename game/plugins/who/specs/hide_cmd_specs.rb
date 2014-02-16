require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe HideCmd do
      include MockClient

      before do
        @hide = HideCmd.new
        @cmd = double
        @client = double
        @hide.cmd = @cmd
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :want_command do
        it "should want the hide command from a logged in player" do
          @cmd.stub(:root_is?).with("hide") { true }
          @client.stub(:logged_in?) { true }
          @hide.want_command?(@client, @cmd).should be_true
        end

        it "should not want the hide command from a player who isn't logged in" do
          @cmd.stub(:root_is?).with("hide") { true }
          @client.stub(:logged_in?) { false }
          @hide.want_command?(@client, @cmd).should be_false
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("hide") { false }
          @client.stub(:logged_in?) { true }
          @hide.want_command?(@client, @cmd).should be_false
        end
      end
      
      describe :validate do
        it "should be valid if there are no args" do
          @cmd.stub(:root_only?) { true }
          @hide.validate.should be_nil
        end
        
        it "should be invalid if there are args" do
          @cmd.stub(:root_only?) { false }
          @hide.validate.should eq 'who.invalid_hide_syntax'
        end
      end

      describe :handle do        
        before do
          @mock_client = build_mock_client
          @hide.client = @mock_client[:client]
          SpecHelpers.stub_translate_for_testing
        end

        it "should toggle the hidden flag on" do
          @mock_client[:char].should_receive(:hidden) { false }
          @mock_client[:char].should_receive(:hidden=).with(true)
          @mock_client[:client].should_receive(:emit_success).with('who.hide_enabled')
          @hide.handle
        end
        
        it "should toggle the hidden flag off" do
          @mock_client[:char].should_receive(:hidden) { true }
          @mock_client[:char].should_receive(:hidden=).with(false)
          @mock_client[:client].should_receive(:emit_success).with('who.hide_disabled')
          @hide.handle
        end
      end
    end
  end
end