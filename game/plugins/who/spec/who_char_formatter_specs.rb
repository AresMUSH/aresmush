require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoCharFormatter do
      before do
        container = mock(Container)
        @client = mock(Client)
        @config_reader = mock(ConfigReader)
        container.stub(:config_reader) { @config_reader }
        @formatter = WhoCharFormatter.new(@client, container)
      end

      describe :format do
        it "should use the char format" do
          @config_reader.stub(:config) {{ "who" => { "char_format" => "mycharformat"} }}
          @formatter.format.should eq "mycharformat"
        end
      end

      describe :render_default do
        it "should render with the format string" do
          @config_reader.stub(:config) {{ "who" => { "char_format" => "mycharformat"} }}
          @formatter.should_receive(:render).with("mycharformat")
          @formatter.render_default
        end
      end
      
      describe :widths do
        it "should define the default field widths" do
          @formatter.name_width.should eq 20
          @formatter.status_width.should eq 5
          @formatter.idle_width.should eq 5
        end        
      end
      
      describe :fields do
        it "should define the default fields" do
          @client.stub(:name) { "NAME" }
          @client.stub(:idle) { "IDLE" }
          @client.stub(:char) {  { "status" => "STAT" } }
          
          @formatter.name.should eq "NAME                "
          @formatter.idle.should eq "IDLE "
          @formatter.status.should eq "STAT "
        end
      end
      
    end
  end
end