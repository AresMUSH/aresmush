module AresMUSH
  module Manage
    describe Manage do
      describe :can_manage_object? do
        before do
          @admin = double
          @admin.stub(:has_permission?).with("manage_game") { true }
          @admin.stub(:has_permission?).with("build") { false }

          @builder = double
          @builder.stub(:has_permission?).with("manage_game") { false }
          @builder.stub(:has_permission?).with("build") { true }

          @player = double
          @player.stub(:has_permission?).with("manage_game") { false }
          @player.stub(:has_permission?).with("build") { false }
          
          @room = Room.new
          @exit = Exit.new
          @char = Character.new
        end
          
        it "should allow someone with room permissions to manage a room" do
          Manage.can_manage_object?(@builder, @room).should be true
        end

        it "should allow someone with game permissions to manage a room" do
          Manage.can_manage_object?(@admin, @room).should be true
        end

        it "should not allow someone without permissions to manage a room" do
          Manage.can_manage_object?(@player, @room).should be false
        end

        it "should allow someone with room permissions to manage an exit" do
          Manage.can_manage_object?(@builder, @exit).should be true
        end

        it "should allow someone with game permissions to manage an exit" do
          Manage.can_manage_object?(@admin, @exit).should be true
        end

        it "should not allow someone without permissions to manage a room" do
          Manage.can_manage_object?(@player, @exit).should be false
        end

        it "should allow someone with game permissions to manage a character" do
          Manage.can_manage_object?(@admin, @char).should be true
        end

        it "should not allow someone with char permissions to manage a character" do
          Manage.can_manage_object?(@builder, @char).should be false
        end
      end
    end
  end
end