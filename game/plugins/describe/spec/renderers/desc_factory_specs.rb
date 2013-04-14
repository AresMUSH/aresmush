require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe DescFactory do
      before do
        @container = double(Container)
        @renderer = mock
      end

      describe :build do
        it "should create a renderer for a room" do
          model = { "type" => "Room" }
          RoomRenderer.should_receive(:new).with(model, @container) { @renderer }
          DescFactory.build(model, @container).should eq @renderer
        end

        it "should create a renderer for a character" do
          model = { "type" => "Character" }
          CharRenderer.should_receive(:new).with(model, @container) { @renderer }
          DescFactory.build(model, @container).should eq @renderer
        end

        it "should create a renderer for an exit" do
          model = { "type" => "Exit" }
          ExitRenderer.should_receive(:new).with(model, @container) { @renderer }
          DescFactory.build(model, @container).should eq @renderer
        end
      end

      describe "room renderers" do
        before do
          @model = mock
        end

        it "should build the header renderer" do
          RoomHeaderRenderer.should_receive(:new).with(@model, @container)
          DescFactory.build_room_header_renderer(@model, @container)
        end

        it "should build the footer renderer" do
          RoomFooterRenderer.should_receive(:new).with(@model, @container)
          DescFactory.build_room_footer_renderer(@model, @container)
        end

        it "should build the content renderer" do
          RoomContentRenderer.should_receive(:new).with(@model, @container)
          DescFactory.build_room_content_renderer(@model, @container)
        end

        it "should build the exit renderer" do
          RoomExitRenderer.should_receive(:new).with(@model, @container)
          DescFactory.build_room_exit_renderer(@model, @container)
        end
      end
    end
  end
end