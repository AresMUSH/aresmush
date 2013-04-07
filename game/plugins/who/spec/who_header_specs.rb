require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoHeader do
      before do
        container = mock(Container)
        @config_reader = mock(ConfigReader)
        container.stub(:config_reader) { @config_reader }
        @formatter = WhoHeader.new([], container)
      end

      describe :template do
        it "should use the header template" do
          @config_reader.stub(:config) {{ "who" => { "header" => "template"} }}
          @formatter.template.should eq "template"
        end
      end
      
      describe :mush_name do
        it "should provide the mush name" do
          @config_reader.stub(:config) {{ "theme" => { "mush_name" => "mymushname"} }}          
          @formatter.mush_name.should eq "mymushname"
        end
      end
      
    end
  end
end