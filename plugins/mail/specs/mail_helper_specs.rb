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
    end
  end
end

