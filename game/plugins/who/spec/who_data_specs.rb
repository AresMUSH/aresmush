require_relative "../../plugin_test_loader"

module AresMUSH
  
  module Who
    describe WhoData do
      include MockClient
      describe :online_record do
        it "should read online record" do
          data = WhoData.new(@clients)
          AresMUSH::Locale.stub(:translate).with("who.online_record", { :count => 22 }) { "record 22" }
          Game.should_receive(:online_record) { 22 }
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
          mock_client1 = build_mock_client
          mock_client1[:char].stub(:is_ic?) { true }

          mock_client2 = build_mock_client
          mock_client2[:char].stub(:is_ic?) { false }

          mock_client3 = build_mock_client
          mock_client3[:char].stub(:is_ic?) { true }
                    
          data = WhoData.new([mock_client1[:client], mock_client2[:client], mock_client3[:client]])
          data.ic_total.should eq "ic 2"
        end
      end
    
    end
  end
end