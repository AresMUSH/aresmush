require_relative "../../plugin_test_loader"

module AresMUSH
  
  module Who
    describe WhoClientData do
      include MockClient
      
      describe :sort do
        it "should sort by location then name" do
          
          c1 = build_mock_client
          c1[:char].stub(:who_location) { "B Room" }
          c1[:char].stub(:name) { "Zulu" }
          
          c2 = build_mock_client
          c2[:char].stub(:who_location) { "A Room" }
          c2[:char].stub(:name) { "Tango" }
          
          c3 = build_mock_client
          c3[:char].stub(:who_location) { "B Room" }
          c3[:char].stub(:name) { "Hotel" }
          
          WhoClientData.sort([c1[:client], c2[:client], c3[:client]]).should eq [c2[:client], c3[:client], c1[:client]]
        end
      end
    end
  end
end