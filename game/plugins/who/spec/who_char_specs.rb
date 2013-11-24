require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoChar do
      before do
        container = double(Container)
        @client = double(Client)
        setup_character
        @formatter = WhoChar.new(@client, container)
      end
      
      def setup_character
        @char = double("Char")
        @client.stub(:char) { @char }
        HashReader.stub(:new) { double }
      end  

      describe :template do
        it "should use the char template" do
          Global.stub(:config) {{ "who" => { "each_char" => "template"} }}
          @formatter.template.should eq "template"
        end        
      end
      
      describe :fields do
        it "should define the default fields" do
          @client.stub(:name) { "NAME" }
          @client.stub(:idle) { "IDLE" }
          
          @formatter.name.should eq "NAME"
          @formatter.idle.should eq "IDLE"
        end
      end
      
    end
  end
end