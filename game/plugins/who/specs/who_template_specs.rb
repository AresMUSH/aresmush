require_relative "../../plugin_test_loader"

module AresMUSH
  
  module Who
    describe WhoTemplate do
      include MockClient
      describe :online_record do
        it "should read online record" do
          data = WhoTemplate.new(@clients)
          AresMUSH::Locale.stub(:translate).with("who.online_record", { :count => 22 }) { "record 22" }
          Game.should_receive(:online_record) { 22 }
          data.online_record.should eq "record 22".center(25)
        end
      end

      describe :online_total do
        it "should count the people" do
          AresMUSH::Locale.stub(:translate).with("who.players_online", { :count => 2 }) { "online 2" }
          clients = [double, double]
          data = WhoTemplate.new(clients)
          data.online_total.should eq "online 2".center(25)
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
                    
          data = WhoTemplate.new([mock_client1[:client], mock_client2[:client], mock_client3[:client]])
          data.ic_total.should eq "ic 2".center(25)
        end
      end
    
      describe :clients do
        it "should return the list of clients sorted by location then name" do
          
          c1 = build_mock_client
          c1[:char].stub(:who_room_name) { "B Room" }
          c1[:char].stub(:name) { "Zulu" }
          
          c2 = build_mock_client
          c2[:char].stub(:who_room_name) { "A Room" }
          c2[:char].stub(:name) { "Tango" }
          
          c3 = build_mock_client
          c3[:char].stub(:who_room_name) { "B Room" }
          c3[:char].stub(:name) { "Hotel" }
          
          data = WhoTemplate.new([c1[:client], c2[:client], c3[:client]])
          data.clients.should eq [c2[:client], c3[:client], c1[:client]]
        end
      end
      
    end
  end
end