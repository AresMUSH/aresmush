require_relative "../../plugin_test_loader"

module AresMUSH
  
  module Who
    describe WhoData do
      
      RSpec.configure do |c|
        c.include ClientBuilder
      end
      
      describe :online_record do
        it "should read online record" do
          data = WhoData.new(@clients)
          AresMUSH::Locale.stub(:translate).with("who.online_record", { :count => 22 }) { "record 22" }
          Who.should_receive(:online_record) { 22 }
          data.online_record.should eq "record 22"
        end
      end

      describe :online_total do
        it "should count the people" do
          AresMUSH::Locale.stub(:translate).with("who.players_online", { :count => 2 }) { "online 2" }
          clients = [double, double]
          data = WhoData.new(clients)
          data.online_total.should eq "online 2"
        end
      end

      describe :ic_total do
        it "should count IC people" do
          AresMUSH::Locale.stub(:translate).with("who.players_ic", { :count => 2 }) { "ic 2" }
          client1 = make_dummy_client(true, false)
          client2 = make_dummy_client(true, true)
          client3 = make_dummy_client(true, true)
          
          data = WhoData.new([client1, client2, client3])
          data.ic_total.should eq "ic 2"
        end
      end
    
    end
  end
end