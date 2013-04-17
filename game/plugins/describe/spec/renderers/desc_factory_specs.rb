require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe DescFactory do
      before do
        @container = double(Container)
        @config_reader = double(ConfigReader)
        @container.stub(:config_reader) { @config_reader }
        @renderer = mock
        @factory = DescFactory.new(@container)
      end

      describe :build do
        before do
          @factory.stub(:exit_config) { "EXIT_CONFIG" }
          @factory.stub(:room_config) { "ROOM_CONFIG" }
          @factory.stub(:char_config) { "CHAR_CONFIG" }
        end
        it "should create a renderer for a room" do
          model = { "type" => "Room" }
          RoomRenderer.should_receive(:new).with(model) { @renderer }
          @factory.build(model).should eq @renderer
        end

        it "should create a renderer for a character" do
          model = { "type" => "Character" }
          TemplateRenderer.should_receive(:new).with("CHAR_CONFIG", model) { @renderer }
          @factory.build(model).should eq @renderer
        end

        it "should create a renderer for an exit" do
          model = { "type" => "Exit" }
          TemplateRenderer.should_receive(:new).with("EXIT_CONFIG", model) { @renderer }
          @factory.build(model).should eq @renderer
        end
      end
    end
  end
end