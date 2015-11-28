require_relative "../../plugin_test_loader"

module AresMUSH
  module Bbs
    
    describe BbsBoardCmd do
      include CommandHandlerTestHelper
      
      before do
        init_handler(BbsBoardCmd, "bbs/foo board")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :want_command do
        it "should not want something with a switch" do
          init_handler(BbsBoardCmd, "bbs/foo board")
          handler.want_command?(client, cmd).should be_false
        end
        
        it "should not want a post read" do
          init_handler(BbsBoardCmd, "bbs board/1")
          handler.want_command?(client, cmd).should be_false
        end
        
        it "should want a board read" do
          init_handler(BbsBoardCmd, "bbs board")
          handler.want_command?(client, cmd).should be_true
        end
      end
    end
  end
end