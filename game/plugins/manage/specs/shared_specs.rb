module AresMUSH
  module Manage
    describe Manage do
      describe :can_manage_object? do
        before do
          @admin = double
          @admin.stub(:has_any_role?).with(["admin"]) { true }
          @admin.stub(:has_any_role?).with(["builder"]) { false }

          @builder = double
          @builder.stub(:has_any_role?).with(["admin"]) { false }
          @builder.stub(:has_any_role?).with(["builder"]) { true }

          @room = Room.new
          @exit = Exit.new
          @char = Character.new

          Global.stub(:read_config).with("manage", "roles", "can_manage_players") { ['admin'] }
          Global.stub(:read_config).with("manage", "roles", "can_manage_rooms") { ['builder'] }
        end
          
        it "should allow someone with room permissions to manage a room" do
          Manage.can_manage_object?(@builder, @room).should be true
        end

        it "should not allow someone without room permissions to manage a room" do
          Manage.can_manage_object?(@admin, @room).should be false
        end

        it "should allow someone with room permissions to manage an exit" do
          Manage.can_manage_object?(@builder, @exit).should be true
        end

        it "should not allow someone with room permissions to manage an exit" do
          Manage.can_manage_object?(@admin, @exit).should be false
        end

        it "should allow someone with char permissions to manage a character" do
          Manage.can_manage_object?(@admin, @char).should be true
        end

        it "should not allow someone with char permissions to manage a character" do
          Manage.can_manage_object?(@builder, @char).should be false
        end
      end
    end
  end
end