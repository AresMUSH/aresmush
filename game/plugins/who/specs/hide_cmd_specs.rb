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
        @hide.client = @client
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :want_command do
        it "should want the hide command" do
          @cmd.stub(:root_is?).with("hide") { true }
          @hide.want_command?(@client, @cmd).should be_true
        end

        it "should not want another command" do
          @cmd.stub(:root_is?).with("hide") { false }
          @hide.want_command?(@client, @cmd).should be_false
        end
      end
      
      describe :validate do
        it "should reject the command if there are args" do
          @client.stub(:logged_in?) { true }
          @cmd.stub(:root_only?) { false }
          @hide.validate.should eq 'who.invalid_hide_syntax'
        end
        
        it "should reject the command if not logged in" do
          @cmd.stub(:root_only?) { true }
          @client.stub(:logged_in?) { false }            
          @hide.validate.should eq 'dispatcher.must_be_logged_in'
        end
        
        it "should accept the command otherwise" do
          @client.stub(:logged_in?) { true }
          @cmd.stub(:root_only?) { true }
          @hide.validate.should be_nil 
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