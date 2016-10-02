require_relative "../../plugin_test_loader"

module AresMUSH
  module Bbs
    
    describe BbsPostCmd do
      include CommandHandlerTestHelper
      
      before do
        @board = double
        BbsBoard.stub(:find_one).with("announce") { @board }

        init_handler(BbsPostCmd, "bbs/edit board=subj/msg")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :crack do 
        
        it "should ignore a missing arg" do
          init_handler(BbsPostCmd, "bbs/post board=subj")
          handler.crack!
          handler.board_name.should be_nil
          handler.subject.should be_nil
          handler.message.should be_nil
        end
        
        context "Myrddin syntax" do
          it "should handle the Myrddin syntax" do
            init_handler(BbsPostCmd, "bbs/post board/subj=msg")
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg"
          end

          it "should stop the subject after the first slash" do
            init_handler(BbsPostCmd, "bbs/post board/subj=msg with a / slash")
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a / slash"
          end
        
          it "should stop the subjecta fter the first equals" do
            init_handler(BbsPostCmd, "bbs/post board/subj=msg with a = equals")
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a = equals"
          end
        end
      
        context "Fara syntax" do
          it "should handle the Fara syntax" do
            init_handler(BbsPostCmd, "bbs/post board=subj/msg")
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg"
          end
        
          it "should stop the subject after the first slash" do
            init_handler(BbsPostCmd, "bbs/post board=subj/msg with a / slash")
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a / slash"
          end
        
          it "should stop the subject after the first equals" do
            init_handler(BbsPostCmd, "bbs/post board=subj/msg with a = equals")
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a = equals"
          end
        end
      end
    end
  end
end