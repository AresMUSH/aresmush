module AresMUSH
  module Handles
    describe UnlinkCmdHandler do
      include ApiHandlerTestHelper
      
      let(:expected_cmd) { "unlink" }
      
      before do
        Global.api_router = ApiRouter.new(false)
        @char = Character.new(name: "Bob", handle: "@Star")
        @char.stub(:api_character_id) { "ABC" }
        Character.stub(:all) { [ @char ] }
        SpecHelpers.stub_translate_for_testing
      end
      
      it "should fail if handle char not found" do
        cmd = ApiCommand.create_from("unlink @Star||XXX")
        response = Global.api_router.route_command(1, cmd )
        check_response(response, ApiResponse.error_status, "api.invalid_char_id")
      end
      
      it "should fail if character doesn't have that handle" do
        cmd = ApiCommand.create_from("unlink @XXX||ABC")
        response = Global.api_router.route_command(1, cmd)
        check_response(response, ApiResponse.error_status, "api.character_not_linked")
      end
      
      context "success" do
        before do
          Mail.stub(:send_mail)
          @game = double
          @system_char = double
          Game.stub(:master) { @game }
          @game.stub(:system_character) { @system_char }
          @char.stub(:save!)
        end
        
        it "should clear the handle" do
          cmd = ApiCommand.create_from("unlink @Star||ABC")
          @char.should_receive(:save!) { }
          response = Global.api_router.route_command(1, cmd)
          check_response(response, ApiResponse.ok_status, "")
          @char.handle.should be_nil
        end
        
        it "should send mail" do
          cmd = ApiCommand.create_from("unlink @Star||ABC")
          Mail.should_receive(:send_mail).with(["Bob"], 
            "handles.char_unlinked_subject", 
            "handles.char_unlinked_body",
            nil)
          response = Global.api_router.route_command(1, cmd)
          check_response(response, ApiResponse.ok_status, "")
        end
      end
    end
  end
end