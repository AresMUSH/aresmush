require_relative "../../plugin_test_loader"

module AresMUSH

  module Who
    describe WhoEvents do
      
      before do
        @client_monitor = double
        Global.stub(:client_monitor) { @client_monitor }
        @events = WhoEvents.new
      end
      
      describe :on_char_connected do
        context "online record set" do
          before do 
            Who.stub(:online_record) { 2 }
            @client_monitor.stub(:logged_in_clients) { [double, double, double] }            
            @client_monitor.stub(:emit_all) {} 
            AresMUSH::Locale.stub(:translate).with("who.new_online_record", { :count => 3 }) { "record 3" }            
          end
          
          it "should update the online record" do
            Who.should_receive(:online_record=).with(3)
            @events.on_char_connected(nil)
          end
          
          it "should emit the new record" do
            @client_monitor.should_receive(:emit_all).with("record 3")
            @events.on_char_connected(nil)            
          end
        end
      
        context "online record not set" do
          before do
            Who.stub(:online_record) { 2 }
            @client_monitor.stub(:logged_in_clients) { [double, double] }                        
          end
          
          it "should not update the online record" do
            Who.should_not_receive(:online_record=)
            @events.on_char_connected(nil)            
          end
          
          it "should not emit a new record" do
            @client_monitor.should_not_receive(:emit_all).with("record 3")
            @events.on_char_connected(nil)            
          end
        end
      end
    end
  end
end