module AresMUSH
  module Mail
    describe Mail do

      describe :select_message_range do
        
        it "should return nil if not a number" do
          
          expect(Mail.select_message_range("x")).to be_nil
          expect(Mail.select_message_range("-2")).to be_nil
          expect(Mail.select_message_range("1-y")).to be_nil
          expect(Mail.select_message_range("x-2")).to be_nil
          expect(Mail.select_message_range("1-2-3")).to be_nil
          
        end
        
        it "should return a single message" do
          expect(Mail.select_message_range("2")).to eq [ 2 ]
          
        end
        
        it "should return multiple messages reversed" do
          expect(Mail.select_message_range("2-5")).to eq [ 5, 4, 3, 2 ]          
        end
        
      end
      
      describe :empty_old_trash do
        before do
          @enactor = double     
          allow(@enactor).to receive(:name) { "Bob" }     
        end
        
        it "should not delete if emptied this week" do
          expect(@enactor).to_not receive(:mail) { [] }
          expect(@enactor).to receive(:mail_trash_last_emptied) { Time.now - 86400 }
          Mail.empty_old_trash(@enactor)
        end
                
        it "should delete message older than 30 days" do
          msg = double
          expect(msg).to receive(:in_trash?) { true }
          expect(msg).to receive(:trashed_time) { Time.now - 86400*31 }
          expect(msg).to receive(:delete)
          expect(@enactor).to receive(:mail_trash_last_emptied) { Time.now - 86400*8 }

          messages = [msg]
          expect(@enactor).to receive(:mail) { messages }
          expect(@enactor).to receive(:update)
                      
          Mail.empty_old_trash(@enactor)
            
        end
        
        it "should keep message newer than 30 days" do
          msg = double
          expect(msg).to receive(:in_trash?) { true }
          expect(msg).to receive(:trashed_time) { Time.now - 86400*29 }
          expect(msg).to_not receive(:delete)
          expect(@enactor).to receive(:mail_trash_last_emptied) { Time.now - 86400*8 }

          messages = [msg]
          expect(@enactor).to receive(:mail) { messages }
          expect(@enactor).to receive(:update)

          Mail.empty_old_trash(@enactor)          
        end
        
        it "should keep message not in trash" do
          msg = double
          expect(msg).to receive(:in_trash?) { false }
          expect(msg).to_not receive(:delete)
          expect(@enactor).to receive(:mail_trash_last_emptied) { Time.now - 86400*8 }
          expect(@enactor).to receive(:update)

          messages = [msg]
          expect(@enactor).to receive(:mail) { messages }
            
          Mail.empty_old_trash(@enactor)          
        end
        
      end
      
    end
  end
end

