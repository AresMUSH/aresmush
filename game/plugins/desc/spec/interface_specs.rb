require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Desc do
      before do
        @client = double(Client)
        @client.stub(:emit_success)        
        Player.stub(:update)
        AresModel.stub(:model_class) { Player }
        @model = { "name" => "Bob", "type" => "player" }          
        
        AresMUSH::Locale.stub(:translate).with("describe.desc_set", { :name => "Bob" }) { "desc_set" }
      end
      
      describe :set_desc do
        it "should set the desc on the model" do
          Describe.set_desc(@client, @model, "New desc")
          @model["desc"].should eq "New desc"
        end

        it "should save the model" do
          AresModel.should_receive(:model_class).with(@model) { Player }
          Player.should_receive(:update).with(@model)
          Describe.set_desc(@client, @model, "New desc")          
        end
        
        it "should emit success to the client" do
          @client.should_receive(:emit_success).with("desc_set")
          Describe.set_desc(@client, @model, "New desc")          
        end
      end
      
      describe :get_desc do
        it "should call the room format method for a room" do
          model = { "type" => "Room" }
          Describe.should_receive(:format_room_desc).with(model) { "room desc" }
          Describe.get_desc(model).should eq "room desc"
        end

        it "should call the player format method for a player" do
          model = { "type" => "Player" }
          Describe.should_receive(:format_player_desc).with(model) { "player desc" }
          Describe.get_desc(model).should eq "player desc"
        end

        it "should just return the desc if there's no format method" do
          model = { "type" => "Foo", "desc" => "foo desc" }
          Describe.get_desc(model).should eq "foo desc"
        end     
      end
    end
    
    describe :format_player_desc do
      # TODO
    end

    describe :format_room_desc do
      # TODO
    end
  end
end