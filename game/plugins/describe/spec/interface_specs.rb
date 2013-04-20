require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Desc do
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
          @container = mock(Container)
          @desc_factory = mock(DescFactory)
          DescFactory.stub(:new) { @desc_factory }
          
          @interface = DescFunctions.new(@container)
        end
        
        it "should build the proper renderer" do
          model = { "type" => "Room" }
          renderer = mock.as_null_object
          @desc_factory.should_receive(:build).with(model) { renderer }
          @interface.get_desc(model)
        end

        it "should call the renderer" do
          model = { "type" => "Character" }
          renderer = mock
          @desc_factory.stub(:build) { renderer }
          renderer.should_receive(:render)
          @interface.get_desc(model)
        end
        
        it "should return the formatted results of the render" do
          model = { "type" => "Character" }
          renderer = mock
          @desc_factory.stub(:build) { renderer }
          renderer.stub(:render) { "DESC" }
          @interface.get_desc(model).should eq "DESC"
        end
      end
    end
    
  end
end