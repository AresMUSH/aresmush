require "plugin_test_loader"

module AresMUSH
  module Channels
    describe :prune_channel_recall do
      before do
        @channel = double
        @msg1 = double
        @msg2 = double
        @msg3 = double
        @msg4 = double
        @msg5 = double
      end
      
      
      it "should do nothing if under the buffer limit" do
        allow(@channel).to receive(:sorted_channel_messages) { [ @msg1, @msg2 ] }
        allow(Channels).to receive(:recall_buffer_size) { 5 }
        
        expect(@msg1).to_not receive(:delete)
        expect(@msg2).to_not receive(:delete)
        
        Channels.prune_channel_recall(@channel)
      end
      
      it "should do nothing if at the buffer limit" do
        allow(@channel).to receive(:sorted_channel_messages) { [ @msg1, @msg2 ] }
        allow(Channels).to receive(:recall_buffer_size) { 2 }
        
        expect(@msg1).to_not receive(:delete)
        expect(@msg2).to_not receive(:delete)
        
        Channels.prune_channel_recall(@channel)
      end
      
      it "should cull messages over the limit" do
        allow(@channel).to receive(:sorted_channel_messages) { [ @msg1, @msg2, @msg3, @msg4 ] }
        allow(Channels).to receive(:recall_buffer_size) { 2 }
        
        expect(@msg1).to receive(:delete)
        expect(@msg2).to receive(:delete)
        expect(@msg3).to_not receive(:delete)
        expect(@msg4).to_not receive(:delete)
        
        Channels.prune_channel_recall(@channel)
      end
      
    end
  end
end
