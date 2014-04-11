module AresMUSH
  module Rooms
    describe GoCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(GoCmd, "go S")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "go" }
      end
      
      describe :handle do
        before do
          handler.stub(:destination) { "s" }
          @room = double
          client.stub(:room) { @room }
        end
        
        context "exit not found" do
          before do
            exits = [ ]
            @room.stub(:exits) { exits }
            client.stub(:emit_failure)
          end  
          
          it "should emit failure" do
            client.should_receive(:emit_failure).with("rooms.cant_go_that_way")          
            handler.handle
          end
          
          it "should not go anywhere" do
            Rooms.should_not_receive(:move_to)
            handler.handle
          end
        end
        
        context "exit found" do          
          before do
            @exit = Exit.new(name_upcase: "S")
            exits = [ @exit ]
            @room.stub(:exits) { exits }
          end

          it "should go to the exit destination if there is one" do
            other_room = double
            @exit.stub(:dest) { other_room }
            Rooms.should_receive(:move_to).with(client, char, other_room)
            handler.handle
          end
          
          it "should emit failure if there is no destination" do
            @exit.stub(:dest) { nil }
            Rooms.should_not_receive(:move_to)
            client.should_receive(:emit_failure).with("rooms.cant_go_that_way")
            handler.handle
          end
        end
        
      end
    end
  end
end