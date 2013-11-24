require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoFooter do
      before do
        container = double(Container)
        @client1 = double("Client1")
        @client2 = double("Client2")
        @formatter = WhoFooter.new([@client1, @client2], container)
      end

      describe :template do
        it "should use the footer template" do
          Global.stub(:config) {{ "who" => { "footer" => "template"} }}
          @formatter.template.should eq "template"
        end
      end
      
      describe :online_total do
        it "should count the players online" do
          @formatter.online_total.should eq 2
        end
      end
      
      describe :ic_total do
        it "should count the number of IC players" do
          char1 = double("Char1")
          char2 = double("Char2")
          @client1.stub(:char) { char1 }
          @client2.stub(:char) { char2 }
          Who.should_receive(:is_ic?).with(char1) { false }
          Who.should_receive(:is_ic?).with(char2) { true }
          @formatter.ic_total.should eq 1 
        end
      end
      
    end
  end
end