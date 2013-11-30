require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoRenderer do
      before do
        @client1 = double(Client)
        @client2 = double(Client)
        @clients = [@client1, @client2]
        
        @header_template = double
        @footer_template = double
        @char_template = double
        
        @data = double(WhoData).as_null_object
        WhoData.stub(:new).with(@clients) { @data }
        
        @who = WhoRenderer.new(@header_template, @char_template, @footer_template)
      end

      describe :render do
        it "should string together the three components" do
          @who.stub(:build_chars) { "CHARS" }
          @who.stub(:build_header) { "HEADER" }
          @who.stub(:build_footer) { "FOOTER" }
          @who.render(@clients).should eq "HEADERCHARSFOOTER"
        end
      end
      
      describe :build_header do
        it "should render the header template" do
          @who.stub(:build_chars) { "CHARS" }
          @who.stub(:build_footer) { "FOOTER" }
          @header_template.should_receive(:render).with(@data) { "HEADER"}
          @who.render(@clients).should eq "HEADERCHARSFOOTER"
        end
      end
      
      describe :build_footer do
        it "should render the footer template" do
          @who.stub(:build_header) { "HEADER" }
          @who.stub(:build_chars) { "CHARS" }
          @footer_template.should_receive(:render).with(@data) { "FOOTER"}
          @who.render(@clients).should eq "HEADERCHARSFOOTER"
        end
      end

      describe :build_chars do
        it "should render each char" do
          @who.stub(:build_header) { "HEADER" }
          @who.stub(:build_footer) { "FOOTER" }

          @data.stub(:clients) { @clients }

          char1 = { "name" => "1" }
          char2 = { "name" => "2" }
          WhoCharData.should_receive(:new).with(@client1) { char1 }
          WhoCharData.should_receive(:new).with(@client2) { char2 }

          @char_template.should_receive(:render).with(char1) { "C1" }
          @char_template.should_receive(:render).with(char2) { "C2" }

          @who.render(@clients).should eq "HEADER\nC1\nC2\nFOOTER"          
        end
      end
    end
  end
end