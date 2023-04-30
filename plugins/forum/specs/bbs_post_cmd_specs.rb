require "plugin_test_loader"

module AresMUSH
  module Forum
    
    describe ForumPostCmd do
      before do
        @category = double
        allow(BbsBoard).to receive(:find_one_by_name).with("announce") { @category }

        stub_translate_for_testing
      end
      
      
      describe :crack do 
        
        it "should ignore a missing arg" do
          handler = ForumPostCmd.new(nil, Command.new("forum/post category=subj"), nil)
          handler.parse_args
          expect(handler.category_name).to be_nil
          expect(handler.subject).to be_nil
          expect(handler.message).to be_nil
        end
        
        context "Myrddin syntax" do
          it "should handle the Myrddin syntax" do
            handler = ForumPostCmd.new(nil, Command.new("forum/post category/subj=msg"), nil)
            handler.parse_args
            expect(handler.category_name).to eq "category"
            expect(handler.subject).to eq "subj"
            expect(handler.message).to eq "msg"
          end

          it "should stop the subject after the first slash" do
            handler = ForumPostCmd.new(nil, Command.new("forum/post category/subj=msg with a / slash"), nil)
            handler.parse_args
            expect(handler.category_name).to eq "category"
            expect(handler.subject).to eq "subj"
            expect(handler.message).to eq "msg with a / slash"
          end
        
          it "should stop the subjecta fter the first equals" do
            handler = ForumPostCmd.new(nil, Command.new("forum/post category/subj=msg with a = equals"), nil)
            handler.parse_args
            expect(handler.category_name).to eq "category"
            expect(handler.subject).to eq "subj"
            expect(handler.message).to eq "msg with a = equals"
          end
        end
      
        context "Fara syntax" do
          it "should handle the Fara syntax" do
            handler = ForumPostCmd.new(nil, Command.new("forum/post category=subj/msg"), nil)
            handler.parse_args
            expect(handler.category_name).to eq "category"
            expect(handler.subject).to eq "subj"
            expect(handler.message).to eq "msg"
          end
        
          it "should stop the subject after the first slash" do
            handler = ForumPostCmd.new(nil, Command.new("forum/post category=subj/msg with a / slash"), nil)
            handler.parse_args
            expect(handler.category_name).to eq "category"
            expect(handler.subject).to eq "subj"
            expect(handler.message).to eq "msg with a / slash"
          end
        
          it "should stop the subject after the first equals" do
            handler = ForumPostCmd.new(nil, Command.new("forum/post category=subj/msg with a = equals"), nil)
            handler.parse_args
            expect(handler.category_name).to eq "category"
            expect(handler.subject).to eq "subj"
            expect(handler.message).to eq "msg with a = equals"
          end
        end
      end
    end
  end
end
