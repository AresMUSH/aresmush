require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms  
    describe BuildCmd do
      
      before do
        @client = double
        @enactor = double
        @handler = BuildCmd.new(@client, Command.new("build something"), @enactor)
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :crack do
        it "should crack a name by itself" do
          @handler = BuildCmd.new(@client, Command.new("build Bob's Room"), @enactor)
          @handler.parse_args
          @handler.name.should eq "Bob's Room"
          @handler.exit.should eq ""
          @handler.return_exit.should eq ""
        end
        
        it "should crack a name and exit" do
          @handler = BuildCmd.new(@client, Command.new("build Bob's Room=N"), @enactor)
          @handler.parse_args
          @handler.name.should eq "Bob's Room"
          @handler.exit.should eq "N"
          @handler.return_exit.should eq ""
        end
        
        it "should crack a name exit and return exit" do
          @handler = BuildCmd.new(@client, Command.new("build Bob's Room=N,S"), @enactor)
          @handler.parse_args
          @handler.name.should eq "Bob's Room"
          @handler.exit.should eq "N"
          @handler.return_exit.should eq "S"
        end
      end
      
      describe :handle do
        before do
          @room = double
          @client_room = double
          @enactor.stub(:room) { @client_room }
          Room.stub(:create)
          Rooms.stub(:move_to)
          @client.stub(:emit_success)
          Rooms.stub(:open_exit)
          Room.stub(:create) { @room }
        end
        
        shared_examples "creates room" do
          it "should create the room" do
            Room.should_receive(:create).with( { :name => "A Room" } ) { @room }
            @handler.handle
          end
        
          it "should emit to @client" do
            @client.should_receive(:emit_success).with('rooms.room_created')
            @handler.handle
          end
        
          it "should move the @client to the new room" do
            Rooms.should_receive(:move_to).with(@client, @enactor, @room)
            @handler.handle
          end
        end
      
        shared_examples "creates outgoing exit" do
          it "should create the exit" do
            Rooms.should_receive(:open_exit).with("Exit", @client_room,  @room)
            @handler.handle
          end
        end

        shared_examples "creates return exit" do
          it "should create the exit" do
            Rooms.should_receive(:open_exit).with("Ret Exit", @room,  @client_room)
            @handler.handle
          end
        end
        
        context "creates room" do
          before do
            @handler.stub(:name) { "A Room" }
            @handler.stub(:exit) { "" }
            @handler.stub(:return_exit) { "" }
          end
          
          it_behaves_like "creates room"
        
          it "should not create any exits" do
            Rooms.should_not_receive(:open_exit)
          end
        end
      
        context "room plus exit" do
          before do
            @handler.stub(:name) { "A Room" }
            @handler.stub(:exit) { "Exit" }
            @handler.stub(:return_exit) { "" }
          end
          
          it_behaves_like "creates room"
          it_behaves_like "creates outgoing exit"
          
          it "should not create a return exit" do
            Rooms.should_receive(:open_exit).once
            @handler.handle
          end
        end
        
        context "room plus exit and return exit" do
          before do
            @handler.stub(:name) { "A Room" }
            @handler.stub(:exit) { "Exit" }
            @handler.stub(:return_exit) { "Ret Exit" }
          end

          it_behaves_like "creates room"
          it_behaves_like "creates outgoing exit"
          it_behaves_like "creates return exit"
        end
        
      end
    end
  end
end