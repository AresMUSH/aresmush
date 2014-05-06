require_relative "../../plugin_test_loader"

module AresMUSH
  module Bbs
    
    describe BbsPostCmd do
      include PluginCmdTestHelper
      
      before do
        @board = double
        BbsBoard.stub(:find_by_name).with("announce") { @board }

        init_handler(BbsPostCmd, "bbs board=subj/msg")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :crack do 
        it "should ignore a board read" do
          init_handler(BbsPostCmd, "bbs board")
          handler.want_command?(client, cmd).should be_false
        end
        
        it "should ignore a post read" do
          init_handler(BbsPostCmd, "bbs board/2")
          handler.want_command?(client, cmd).should be_false
        end
        
        it "should ignore a missing arg" do
          init_handler(BbsPostCmd, "bbs board=subj")
          handler.want_command?(client, cmd).should be_false
        end
        
        context "Myrddin syntax" do
          it "should handle the Myrddin syntax" do
            init_handler(BbsPostCmd, "bbs board/subj=msg")
            handler.want_command?(client, cmd).should be_true
            handler.crack!
            handler.name.should be "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg"
          end

          it "should stop the subject after the first slash" do
            init_handler(BbsPostCmd, "bbs board/subj=msg with a / slash")
            handler.want_command?(client, cmd).should be_true
            handler.crack!
            handler.name.should be "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a / slash"
          end
        
          it "should stop the subjecta fter the first equals" do
            init_handler(BbsPostCmd, "bbs board/subj=msg with a = equals")
            handler.want_command?(client, cmd).should be_true
            handler.crack!
            handler.name.should be "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a = equals"
          end
        end
      
        context "Fara syntax" do
          it "should handle the Fara syntax" do
            init_handler(BbsPostCmd, "bbs board=subj/msg")
            handler.want_command?(client, cmd).should be_true
            handler.crack!
            handler.name.should be "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg"
          end
        
          it "should stop the subject after the first slash" do
            init_handler(BbsPostCmd, "bbs board=subj/msg with a / slash")
            handler.want_command?(client, cmd).should be_true
            handler.crack!
            handler.name.should be "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a / slash"
          end
        
          it "should stop the subjecta fter the first equals" do
            init_handler(BbsPostCmd, "bbs board=subj/msg with a = equals")
            handler.want_command?(client, cmd).should be_true
            handler.crack!
            handler.name.should be "board"
            handler.subject.should eq "subj"
            handler.message.should eq "msg with a = equals"
          end
        end
      end
    end
  end
end