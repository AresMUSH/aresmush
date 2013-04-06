require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoHeaderFormatter do
      before do
        container = mock(Container)
        @config_reader = mock(ConfigReader)
        container.stub(:config_reader) { @config_reader }
        @formatter = WhoHeaderFormatter.new([], container)
      end

      describe :format do
        it "should use the header format" do
          @config_reader.stub(:config) {{ "who" => { "header_format" => "myheaderformat"} }}
          @formatter.format.should eq "myheaderformat"
        end
      end

      describe :render_default do
        it "should render with the format string" do
          @config_reader.stub(:config) {{ "who" => { "header_format" => "myheaderformat"} }}
          @formatter.should_receive(:render).with("myheaderformat")
          @formatter.render_default
        end
      end
      
      describe :fields do
        it "should define the default fields" do
          @config_reader.stub(:config) {{ "theme" => { "mush_name" => "mymushname"} }}
          
          @formatter.mush_name.should eq "mymushname"
        end
      end
      
    end
  end
end