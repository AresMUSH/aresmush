require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoHeader do
      before do
        container = double(Container)
        @formatter = WhoHeader.new([], container)
      end

      describe :template do
        it "should use the header template" do
          Global.stub(:config) {{ "who" => { "header" => "template"} }}
          @formatter.template.should eq "template"
        end
      end
      
      describe :mush_name do
        it "should provide the mush name" do
          Global.stub(:config) {{ "theme" => { "mush_name" => "mymushname"} }}          
          @formatter.mush_name.should eq "mymushname"
        end
      end
      
    end
  end
end