require_relative "../../plugin_test_loader"

module AresMUSH
  module Bbs
    
    describe BbsPostCmd do
      before do
        @board = double
        BbsBoard.stub(:find_one_by_name).with("announce") { @board }

        SpecHelpers.stub_translate_for_testing
      end
      
      
      describe :crack do 
        
        it "should ignore a missing arg" do
          handler = BbsPostCmd.new(nil, Command.new("bbs/post board=subj"), nil)
          handler.crack!
          handler.board_name.should be_nil
          handler.subject.should be_nil
          handler.message.should be_nil
        end
        
        context "Myrddin syntax" do
          it "should handle the Myrddin syntax" do
            handler = BbsPostCmd.new(nil, Command.new("bbs/post board/subj=msg"), nil)
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg"
          end

          it "should stop the subject after the first slash" do
            handler = BbsPostCmd.new(nil, Command.new("bbs/post board/subj=msg with a / slash"), nil)
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a / slash"
          end
        
          it "should stop the subjecta fter the first equals" do
            handler = BbsPostCmd.new(nil, Command.new("bbs/post board/subj=msg with a = equals"), nil)
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a = equals"
          end
        end
      
        context "Fara syntax" do
          it "should handle the Fara syntax" do
            handler = BbsPostCmd.new(nil, Command.new("bbs/post board=subj/msg"), nil)
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg"
          end
        
          it "should stop the subject after the first slash" do
            handler = BbsPostCmd.new(nil, Command.new("bbs/post board=subj/msg with a / slash"), nil)
            handler.crack!
            handler.board_name.should eq "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a / slash"
          end
        
          it "should stop the subject after the first equals" do
            handler = BbsPostCmd.new(nil, Command.new("bbs/post board=subj/msg with a = equals"), nil)
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