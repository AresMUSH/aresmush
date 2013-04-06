require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoFooterFormatter do
      before do
        container = mock(Container)
        @config_reader = mock(ConfigReader)
        @client1 = mock("Client1")
        @client2 = mock("Client2")
        container.stub(:config_reader) { @config_reader }
        @formatter = WhoFooterFormatter.new([@client1, @client2], container)
      end

      describe :template do
        it "should use the footer template" do
          @config_reader.stub(:config) {{ "who" => { "footer_template" => "template"} }}
          @formatter.template.should eq "template"
        end
      end

      describe :render_default do
        it "should render with the format string" do
          @config_reader.stub(:config) {{ "who" => { "footer_template" => "template"} }}
          @formatter.should_receive(:render).with("template")
          @formatter.render_default
        end
      end      
      
      describe :online_total do
        it "should count the players online" do
          @formatter.online_total.should eq 2
        end
        
        it "should count the number of IC players" do
          char1 = mock("Char1")
          char2 = mock("Char2")
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