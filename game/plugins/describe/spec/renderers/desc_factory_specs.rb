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
    end
  end
end