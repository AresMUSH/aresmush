module AresMUSH
  module Manage
    describe Manage do
      describe :can_manage_object? do
        before do
          @admin = double
          allow(@admin).to receive(:has_permission?).with("manage_game") { true }
          allow(@admin).to receive(:has_permission?).with("build") { false }

          @builder = double
          allow(@builder).to receive(:has_permission?).with("manage_game") { false }
          allow(@builder).to receive(:has_permission?).with("build") { true }

          @player = double
          allow(@player).to receive(:has_permission?).with("manage_game") { false }
          allow(@player).to receive(:has_permission?).with("build") { false }
          
          @room = Room.new
          @exit = Exit.new
          @char = Character.new
        end
          
        it "should allow someone with room permissions to manage a room" do
          expect(Manage.can_manage_object?(@builder, @room)).to be true
        end

        it "should allow someone with game permissions to manage a room" do
          expect(Manage.can_manage_object?(@admin, @room)).to be true
        end

        it "should not allow someone without permissions to manage a room" do
          expect(Manage.can_manage_object?(@player, @room)).to be false
        end

        it "should allow someone with room permissions to manage an exit" do
          expect(Manage.can_manage_object?(@builder, @exit)).to be true
        end

        it "should allow someone with game permissions to manage an exit" do
          expect(Manage.can_manage_object?(@admin, @exit)).to be true
        end

        it "should not allow someone without permissions to manage a room" do
          expect(Manage.can_manage_object?(@player, @exit)).to be false
        end

        it "should allow someone with game permissions to manage a character" do
          expect(Manage.can_manage_object?(@admin, @char)).to be true
        end

        it "should not allow someone with char permissions to manage a character" do
          expect(Manage.can_manage_object?(@builder, @char)).to be false
        end
      end
    end
  end
end
