$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  class PlayerCommandHandlingTestClass
    def on_player_command
    end
  end
  
  class ArbitraryEventHandlingTestClass
    def on_arbitrary(args)
    end
  end
  
  describe Client do

    before do
      @system_manager = double(SystemManager)
      @client = double(Client).as_null_object
      @dispatcher = Dispatcher.new(@system_manager)
      AresMUSH::Locale.stub(:translate).with("huh") { "huh" }
    end

    describe :on_player_command do
      it "gets the list of systems from the system manager" do
        @system_manager.should_receive(:systems) { [] }
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "won't dispatch to a class that doesn't handle player commands" do
        system1 = Object.new
        @system_manager.stub(:systems) { [ system1, system2 ] }
        system1.should_not_receive(:commands) { [] }
        system1.should_not_receive(:on_player_command) { [] }
        @dispatcher.on_player_command(@client, "test")
      end

      it "asks each system that handles player commands for its commands" do
        system1 = PlayerCommandHandlingTestClass.new
        system2 = PlayerCommandHandlingTestClass.new
        @system_manager.stub(:systems) { [ system1, system2 ] }
        system1.should_receive(:commands) { [] }
        system2.should_receive(:commands) { [] }
        @dispatcher.on_player_command(@client, "test")
      end

      it "calls handle on any system that matches the regex" do
        system1 = PlayerCommandHandlingTestClass.new
        system2 = PlayerCommandHandlingTestClass.new
        system3 = PlayerCommandHandlingTestClass.new
        @system_manager.stub(:systems) { [ system1, system2, system3 ] }
        system1.stub(:commands) { ["test"] }
        system2.stub(:commands) { ["x", "test"] }
        system3.stub(:commands) { ["foo"] }
        system1.should_receive(:on_player_command).with(@client, an_instance_of(MatchData))
        system2.should_receive(:on_player_command).with(@client, an_instance_of(MatchData))
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "passes along the command" do
        system1 = PlayerCommandHandlingTestClass.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.stub(:commands) { ["test .+"] }
        system1.should_receive(:on_player_command) do |client, cmd|
          client.should eq @client
          cmd.should eq "test 1=2"
        end
        @dispatcher.on_player_command(@client, "test 1=2")
      end

      it "parses the command args" do
        system1 = PlayerCommandHandlingTestClass.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.stub(:commands) { ["test (?<arg1>.+)=(?<arg2>.+)"] }
        system1.should_receive(:on_player_command) do |client, cmd|
          client.should eq @client
          cmd[:arg1].should eq "1"
          cmd[:arg2].should eq "2"
        end
        @dispatcher.on_player_command(@client, "test 1=2")
      end

      it "sends huh message if nobody handles the command" do
        system1 = PlayerCommandHandlingTestClass.new
        system1.stub(:commands) { ["x"] }
        @system_manager.stub(:systems) { [ system1 ] }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "catches exceptions from within the command handling" do
        system1 = PlayerCommandHandlingTestClass.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.stub(:commands) { ["test"] }
        system1.stub(:on_player_command).and_raise("an error")
        # TODO - fix message, translate
        @client.should_receive(:emit_failure).with("Bad code did badness! an error")
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "allows a system exit exception to bubble up" do
        system1 = PlayerCommandHandlingTestClass.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.stub(:commands) { ["test"] }
        system1.stub(:on_player_command).and_raise(SystemExit)
        
        expect {@dispatcher.on_player_command(@client, "test")}.to raise_error(SystemExit)
      end
    end

    describe :on_event do
      it "should send the event to any class that handles it" do
        system1 = ArbitraryEventHandlingTestClass.new
        system2 = ArbitraryEventHandlingTestClass.new
        @system_manager.stub(:systems) { [ system1, system2 ] }
        args = { :arg1 => "1" }
        system1.should_receive(:on_arbitrary).with(args)
        system2.should_receive(:on_arbitrary).with(args)
        @dispatcher.on_event("arbitrary", args)
      end

      it "won't send the event to a class that doesn't handle it" do
        system1 = Object.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.should_not_receive(:on_arbitrary)
        @dispatcher.on_event("arbitrary")
      end
    end
  end
end