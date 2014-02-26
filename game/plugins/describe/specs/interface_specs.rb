require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
    describe Describe do
      describe :set_desc do
        before do
          @model = double.as_null_object  
        end
        
        it "should set the desc on the model" do
          @model.should_receive(:description=).with("New desc")
          Describe.set_desc(@model, "New desc")
        end

        it "should save the model" do
          @model.should_receive(:save!)    
          Describe.set_desc(@model, "New desc")
        end        
      end
      
      describe :get_desc do
        before do
          @renderer = double
        end
        
        it "should render a room" do
          model = Room.new
          RendererFactory.stub(:room_renderer) { @renderer }
          @renderer.should_receive(:render).with(model)
          Describe.get_desc(model) 
        end

        it "should render a character" do
          model = Character.new
          RendererFactory.stub(:char_renderer) { @renderer }
          @renderer.should_receive(:render).with(model)
          Describe.get_desc(model) 
        end
        
        it "should render an exit" do
          model = Exit.new
          RendererFactory.stub(:exit_renderer) { @renderer }
          @renderer.should_receive(:render).with(model)
          Describe.get_desc(model) 
        end
      end
    end
    
  end
end