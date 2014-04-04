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
      
      describe :can_describe? do
        before do
          Global.stub(:config) {{ "describe" => { "roles" => { "can_desc_anything" => ['admin', 'powerful'] ,
            "can_desc_places" => ['builder', 'descer'] } }}}
          @client = double
          @char = double
          @client.stub(:char) { @char }
        end
        
        context "describing self" do
          it "should always let you describe yourself" do
            Describe.can_describe?(@client, @char).should be_true
          end
        end
        
        context "describing anything" do
          before do
            @target = double
          end
          
          it "should let someone with desc-anything power describe any object" do
            @char.stub(:has_any_role?).with(["admin", "powerful"]) { true }
            Describe.can_describe?(@client, @target).should be_true
          end

          it "should not let random people describe any object" do
            @char.stub(:has_any_role?).with(["admin", "powerful"]) { false }
            Describe.can_describe?(@client, @target).should be_false
          end
        end
        
        context "describe a room" do
          before do
            @room = Room.new
          end
          
          it "should allow a builder to describe a room" do
            @char.stub(:has_any_role?).with(["admin", "powerful"]) { false }
            @char.stub(:has_any_role?).with(["builder", "descer"]) { true }
            Describe.can_describe?(@client, @room).should be_true
          end
          
          it "should allow someone with desc-anything power to describe a room" do
            @char.stub(:has_any_role?).with(["admin", "powerful"]) { true }
            @char.stub(:has_any_role?).with(["builder", "descer"]) { false }
            Describe.can_describe?(@client, @room).should be_true
          end
          
          it "should not allow someone without permission to describe a room" do
            @char.stub(:has_any_role?).with(["admin", "powerful"]) { false }
            @char.stub(:has_any_role?).with(["builder", "descer"]) { false }
            Describe.can_describe?(@client, @room).should be_false
          end
        end
      end
    end
  end
end