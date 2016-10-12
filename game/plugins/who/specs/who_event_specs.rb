require_relative "../../plugin_test_loader"

module AresMUSH

  module Who
    describe CharConnectedEventHandler do
      include GlobalTestHelper
      
      before do
        stub_global_objects
      end
      
      describe :on_char_connected_event do
        before do
          @events = CharConnectedEventHandler.new
          @master = double
          Game.stub(:master) { @master }
        end

        context "online record set" do
          before do 
            @master.stub(:online_record) { 2 }
            @master.stub(:update) {}
            client_monitor.stub(:logged_in_clients) { [double, double, double] }            
            client_monitor.stub(:emit_all_ooc) {} 
            AresMUSH::Locale.stub(:translate).with("who.new_online_record", { :count => 3 }) { "record 3" }            
          end
          
          it "should update the online record" do
            @master.should_receive(:update).with(online_record: 3)
            @events.on_event(nil)
          end
          
          it "should emit the new record" do
            client_monitor.should_receive(:emit_all_ooc).with("record 3")
            @events.on_event(nil)            
          end
        end
      
        context "online record not set" do
          before do
            @master.stub(:online_record) { 2 }
            client_monitor.stub(:logged_in_clients) { [double, double] }                        
          end
          
          it "should not update the online record" do
            @master.should_not_receive(:update)
            @events.on_event(nil)            
          end
          
          it "should not emit a new record" do
            client_monitor.should_not_receive(:emit_all_ooc)
            @events.on_event(nil)            
          end
        end
      end
    end
  end
end