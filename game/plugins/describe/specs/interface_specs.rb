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
          @model.should_receive(:save)    
          Describe.set_desc(@model, "New desc")
        end        
      end
      
      describe :get_desc do
        before do
          @renderer = double
          @enactor = double
        end
        
        it "should render a room" do
          model = Room.new
          RoomTemplate.should_receive(:new).with(model, @enactor) { @renderer }
          Describe.get_desc_template(model, @enactor).should eq @renderer
        end

        it "should render a character" do
          model = Character.new
          CharacterTemplate.should_receive(:new).with(model) { @renderer }
          Describe.get_desc_template(model, @enactor).should eq @renderer
        end
        
        it "should render an exit" do
          model = Exit.new
          ExitTemplate.should_receive(:new).with(model) { @renderer }
          Describe.get_desc_template(model, @enactor).should eq @renderer
        end
      end
    end
    
  end
end