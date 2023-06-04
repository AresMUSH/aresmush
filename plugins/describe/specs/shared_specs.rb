require "plugin_test_loader"

module AresMUSH
  module Describe
    describe Describe do      
      describe :can_describe? do
        before do
          @char = double
        end
        
        context "describing self" do
          it "should always let you describe yourself" do
            expect(Describe.can_describe?(@char, @char)).to be true
          end
        end
        
        context "describing anything" do
          before do
            @target = double
          end
          
          it "should let someone with desc-anything power describe any object" do
            allow(@char).to receive(:has_permission?).with("desc_anything") { true }
            expect(Describe.can_describe?(@char, @target)).to be true
          end

          it "should not let random people describe any object" do
            allow(@char).to receive(:has_permission?).with("desc_anything") { false }
            expect(Describe.can_describe?(@char, @target)).to be false
          end
        end
        
        context "describe a room" do
          before do
            @room = Room.new
          end
          
          it "should allow a builder to describe a room" do
            allow(@char).to receive(:has_permission?).with("desc_anything") { false }
            allow(@char).to receive(:has_permission?).with("desc_places") { true }
            allow(@room).to receive(:owned_by?).with(@char) { false }
            expect(Describe.can_describe?(@char, @room)).to be true
          end
          
          it "should allow someone with desc-anything power to describe a room" do
            allow(@char).to receive(:has_permission?).with("desc_anything") { true }
            allow(@char).to receive(:has_permission?).with("desc_places") { false }
            allow(@room).to receive(:owned_by?).with(@char) { false }
            expect(Describe.can_describe?(@char, @room)).to be true
          end
          
          it "should allow a room owner to describe a room" do
            allow(@char).to receive(:has_permission?).with("desc_anything") { false }
            allow(@char).to receive(:has_permission?).with("desc_places") { false }
            allow(@room).to receive(:owned_by?).with(@char) { true }
            expect(Describe.can_describe?(@char, @room)).to be true
          end
          
          it "should not allow someone without permission to describe a room" do
            allow(@char).to receive(:has_permission?).with("desc_anything") { false }
            allow(@char).to receive(:has_permission?).with("desc_places") { false }
            allow(@room).to receive(:owned_by?).with(@char) { false }
            expect(Describe.can_describe?(@char, @room)).to be false
          end
        end
      end
    end
  end
end
