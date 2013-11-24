require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe DescFactory do
      before do
        @hash_reader = double
        @renderer = double
        
        Global.stub(:config) {
          {
            "desc" =>
            {
              "exit" => "EXIT_CONFIG",
              "char" => "CHAR_CONFIG",
              "room" =>
              {
                "header" => "ROOM_HEADER",
                "footer" => "ROOM_FOOTER",
                "each_char" => "ROOM_EACH_CHAR",
                "char_header" => "ROOM_CHAR_HEADER",
                "each_exit" => "ROOM_EACH_EXIT",
                "exit_header" => "ROOM_EXIT_HEADER"
              }
            }
          }
        }
        
        @factory = DescFactory.new

      end

      describe :build do
        it "should create a renderer for a room" do
          model = { "type" => "Room" }
          RoomRenderer.should_receive(:new).with(model, @factory) { @renderer }
          @factory.build(model).should eq @renderer
        end

        it "should create a renderer for a character" do
          model = { "type" => "Character" }
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("CHAR_CONFIG", @hash_reader) { @renderer }
          @factory.build(model).should eq @renderer
        end

        it "should create a renderer for an exit" do
          model = { "type" => "Exit" }
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("EXIT_CONFIG", @hash_reader) { @renderer }
          @factory.build(model).should eq @renderer
        end
      end
      
      describe :build_room_exit_header do
        it "should build a renderer with the expected config and a hash reader" do
          model = double
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("ROOM_EXIT_HEADER", @hash_reader) { @renderer }
          @factory.build_room_exit_header(model).should eq @renderer
        end
      end

      describe :build_room_each_exit do
        it "should build a renderer with the expected config and a hash reader" do
          model = double
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("ROOM_EACH_EXIT", @hash_reader) { @renderer }
          @factory.build_room_each_exit(model).should eq @renderer
        end
      end

      describe :build_room_char_header do
        it "should build a renderer with the expected config and a hash reader" do
          model = double
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("ROOM_CHAR_HEADER", @hash_reader) { @renderer }
          @factory.build_room_char_header(model).should eq @renderer
        end
      end

      describe :build_room_each_char do
        it "should build a renderer with the expected config and a hash reader" do
          model = double
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("ROOM_EACH_CHAR", @hash_reader) { @renderer }
          @factory.build_room_each_char(model).should eq @renderer
        end
      end

      describe :build_room_footer do
        it "should build a renderer with the expected config and a hash reader" do
          model = double
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("ROOM_FOOTER", @hash_reader) { @renderer }
          @factory.build_room_footer(model).should eq @renderer
        end
      end

      describe :build_room_header do
        it "should build a renderer with the expected config and a hash reader" do
          model = double
          HashReader.should_receive(:new).with(model) { @hash_reader }
          TemplateRenderer.should_receive(:new).with("ROOM_HEADER", @hash_reader) { @renderer }
          @factory.build_room_header(model).should eq @renderer
        end
      end
                  
    end
  end
end