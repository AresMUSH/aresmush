require_relative "../../plugin_test_loader"

module AresMUSH
  module Bbs
    
    describe BbsReplyCmd do
      include CommandHandlerTestHelper
      
      before do
        init_handler(BbsReplyCmd, "bbs/foo message")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :handle do
        context "Replying to last read" do
          before do 
            init_handler(BbsReplyCmd, "bbs/foo message")
            @post = double
            @board = double
            @post.stub(:bbs_board) { @board }
            client.stub(:program) { {:last_bbs_post => @post} }
          end
          
          it "should use the post and board from the client program" do
            handler.should_receive(:save_reply).with(@board, @post)
            handler.handle
          end  
        end
        
        context "Replying to specific post" do
          before do 
            init_handler(BbsReplyCmd, "bbs/foo 1/2=message")
            handler.crack!
            @post = double
            @board = double
            client.stub(:program) { {} }
          end
          
          it "should use the post and board from the command args" do
            Bbs.should_receive(:with_a_post).with("1", "2", client).and_yield(@board, @post)
            handler.should_receive(:save_reply).with(@board, @post)
            handler.handle
          end  
        end
      end
    end
  end
end