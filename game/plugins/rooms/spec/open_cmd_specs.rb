require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms  
    describe OpenCmd do
      
      before do
        @client = double
        @enactor = double
        @handler = OpenCmd.new(@client, Command.new("open something"), @enactor)
        SpecHelpers.stub_translate_for_testing        
      end
            
      describe :crack do
        it "should crack a name by itself" do
          @handler = OpenCmd.new(@client, Command.new("open N"), @enactor)
          @handler.parse_args
          @handler.name.should eq "N"
          @handler.dest.should be_nil
        end
        
        it "should crack a name and destination" do
          @handler = OpenCmd.new(@client, Command.new("open N=Happy Room"), @enactor)
          @handler.parse_args
          @handler.name.should eq "N"
          @handler.dest.should eq "Happy Room"
        end
      end
      
      describe :handle do
        before do
          @find_result = double
          ClassTargetFinder.stub(:find) { @find_result }
          @client.stub(:emit_failure)
          @client.stub(:emit_success)
          @dest = double
          @client_room = double
          Rooms.stub(:open_exit)
          @enactor.stub(:room) { @client_room }
        end
        
        context "dest not found" do
          before do
            @handler.stub(:dest) { "Room" }
            @find_result = FindResult.new(nil, "error")
            ClassTargetFinder.should_receive(:find).with("Room", Room, @enactor) { @find_result }            
          end
          
          it "should emit the failure message" do
            @client.should_receive(:emit_failure).with("error")
            @handler.handle
          end
          
          it "should not open the exit" do
            Rooms.should_not_receive(:open_exit)
            @handler.handle
          end
        end
        
        context "exit only" do
          before do
            @handler.stub(:name) { "Exit" }
            @handler.stub(:dest) { nil }
          end
          
          it "should not look for the room" do
            ClassTargetFinder.should_not_receive(:find)
            @handler.handle
          end
          
          it "should create the exit to nowhere" do
            Rooms.should_receive(:open_exit).with("Exit", @client_room, nil)
            @handler.handle
          end
        end
        
        context "exit plus destination" do
          before do
            @handler.stub(:name) { "Exit" }
            @handler.stub(:dest) { "Room" }
            @find_result = FindResult.new(@dest, nil)
          end
          
          it "should find the room" do
            ClassTargetFinder.should_receive(:find).with("Room", Room, @enactor)
            @handler.handle
          end
          
          it "should create the exit to the destination" do
            Rooms.should_receive(:open_exit).with("Exit", @client_room, @dest )
            @handler.handle
          end
        end
      end
    end
  end
end