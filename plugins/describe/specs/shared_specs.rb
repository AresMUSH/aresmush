require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
    describe Describe do      
      describe :can_describe? do
        before do
          @char = double
        end
        
        context "describing self" do
          it "should always let you describe yourself" do
            Describe.can_describe?(@char, @char).should be true
          end
        end
        
        context "describing anything" do
          before do
            @target = double
          end
          
          it "should let someone with desc-anything power describe any object" do
            @char.stub(:has_permission?).with("desc_anything") { true }
            Describe.can_describe?(@char, @target).should be true
          end

          it "should not let random people describe any object" do
            @char.stub(:has_permission?).with("desc_anything") { false }
            Describe.can_describe?(@char, @target).should be false
          end
        end
        
        context "describe a room" do
          before do
            @room = Room.new
          end
          
          it "should allow a builder to describe a room" do
            @char.stub(:has_permission?).with("desc_anything") { false }
            @char.stub(:has_permission?).with("desc_places") { true }
            @room.stub(:owned_by?).with(@char) { false }
            Describe.can_describe?(@char, @room).should be true
          end
          
          it "should allow someone with desc-anything power to describe a room" do
            @char.stub(:has_permission?).with("desc_anything") { true }
            @char.stub(:has_permission?).with("desc_places") { false }
            @room.stub(:owned_by?).with(@char) { false }
            Describe.can_describe?(@char, @room).should be true
          end
          
          it "should allow a room owner to describe a room" do
            @char.stub(:has_permission?).with("desc_anything") { false }
            @char.stub(:has_permission?).with("desc_places") { false }
            @room.stub(:owned_by?).with(@char) { true }
            Describe.can_describe?(@char, @room).should be true
          end
          
          it "should not allow someone without permission to describe a room" do
            @char.stub(:has_permission?).with("desc_anything") { false }
            @char.stub(:has_permission?).with("desc_places") { false }
            @room.stub(:owned_by?).with(@char) { false }
            Describe.can_describe?(@char, @room).should be false
          end
        end
      end
    end
  end
end