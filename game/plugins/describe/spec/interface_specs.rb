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
          @model["desc"].should eq "New desc"
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
          @renderer = mock.as_null_object
          @interface = DescFunctions.new(@container)
          Formatter.stub(:perform_subs) { "DESC" }
        end
        
        it "should build the proper renderer" do
          model = { "type" => "Room" }
          DescFactory.should_receive(:build).with(model, @container) { @renderer }
          @interface.get_desc(model)
        end

        it "should return the results of the render" do
          model = { "type" => "Character" }
          DescFactory.stub(:build) { @renderer }
          @renderer.should_receive(:render) { "DESC" }
          Formatter.should_receive(:perform_subs).with("DESC") { "SUBDESC" }
          @interface.get_desc(model).should eq "SUBDESC"
        end
      end
    end
    
  end
end