require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Desc do
      before do
        @client = double(Client)
        @client.stub(:emit_success)        
        Character.stub(:update)
        AresModel.stub(:model_class) { Character }
        @model = { "name" => "Bob", "type" => "char" }          
        
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }
      end
      
      describe :set_desc do
        it "should set the desc on the model" do
          Describe.set_desc(@client, @model, "New desc")
          @model["desc"].should eq "New desc"
        end

        it "should save the model" do
          AresModel.should_receive(:model_class).with(@model) { Character }
          Character.should_receive(:update).with(@model)
          Describe.set_desc(@client, @model, "New desc")          
        end
        
        it "should emit success to the client" do
          @client.should_receive(:emit_success).with("desc_set")
          Describe.set_desc(@client, @model, "New desc")          
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