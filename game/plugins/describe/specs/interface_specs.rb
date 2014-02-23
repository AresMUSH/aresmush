require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Describe do
      describe :set_desc do
        before do
          Character.stub(:update)
          AresModel.stub(:model_class) { Character }
          @model = { "name" => "Bob", "type" => "char" }          
        end
        
        it "should set the desc on the model" do
          Describe.set_desc(@model, "New desc")
          @model["description"].should eq "New desc"
        end

        it "should save the model" do
          AresModel.should_receive(:model_class).with(@model) { Character }
          Character.should_receive(:update).with(@model)
          Describe.set_desc(@model, "New desc")          
        end        
      end
      
      describe :get_desc do
        before do
          @renderer = double
        end
        
        it "should create a renderer for a room" do
          model = { "type" => "Room" }
          RoomRenderer.should_receive(:new).with(model) { @renderer }
          @renderer.should_receive(:render)
          Describe.get_desc(model) 
        end

        it "should create a renderer for a character" do
          model = { "type" => "Character" }
          CharRenderer.should_receive(:new).with(model) { @renderer }
          @renderer.should_receive(:render)
          @factory.build(model)
        end

        it "should create a renderer for an exit" do
          model = { "type" => "Exit" }
          ExitRenderer.should_receive(:new).with(model) { @renderer }
          @renderer.should_receive(:render)
          @factory.build(model)
        end
      end
    end
    
  end
end