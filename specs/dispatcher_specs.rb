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
      @addon_manager = double(AddonManager)
      @client = double(Client).as_null_object
      @dispatcher = Dispatcher.new(@addon_manager)
      AresMUSH::Locale.stub(:translate).with("dispatcher.huh") { "huh" }
      AresMUSH::Locale.stub(:translate).with("dispatcher.error_executing_command", anything()) { "error" }
    end

    describe :on_player_command do
      it "gets the list of addons from the addon manager" do
        @addon_manager.should_receive(:addons) { [] }
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "won't dispatch to a class that doesn't handle player commands" do
        addon1 = Object.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.should_not_receive(:commands) { nil }
        # Can't mock that on_player_command isn't received because the act of mocking it
        # causes the addon to respond to commands!
        @dispatcher.on_player_command(@client, "test")
      end

      it "asks each addon that handles player commands for its commands" do
        addon1 = PlayerCommandHandlingTestClass.new
        addon2 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1, addon2 ] }
        addon1.should_receive(:commands).twice { {} }
        addon2.should_receive(:commands).twice { {} }
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "calls handle on an addon that handles the root command" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "test" => "" } }
        addon1.should_receive(:on_player_command).with(@client, an_instance_of(MatchData))
        @dispatcher.on_player_command(@client, "test/sw arg")
      end
      
      it "can handle a root command with no arg" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "test" => "" } }
        addon1.should_receive(:on_player_command).with(@client, an_instance_of(MatchData))
        @dispatcher.on_player_command(@client, "test/sw")
      end

      it "calls handle even when there are multiple commands handled" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "foo" => "", "test" => "" } }
        addon1.should_receive(:on_player_command).with(@client, an_instance_of(MatchData))
        @dispatcher.on_player_command(@client, "test")
      end

      it "calls handle on multiple addons that match the root command" do
        addon1 = PlayerCommandHandlingTestClass.new
        addon2 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1, addon2 ] }
        addon1.stub(:commands) { { "test" => "" } }
        addon2.stub(:commands) { { "test" => "" } }
        addon1.should_receive(:on_player_command).with(@client, an_instance_of(MatchData))
        addon2.should_receive(:on_player_command).with(@client, an_instance_of(MatchData))
        @dispatcher.on_player_command(@client, "test/sw arg")
      end

      it "doesn't call handle when there's no match" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "foo" => "" } }
        addon1.should_not_receive(:on_player_command)
        @dispatcher.on_player_command(@client, "test/sw arg")
      end
            
      it "passes along the command" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "test" => " .+" } }
        addon1.should_receive(:on_player_command) do |client, cmd|
          client.should eq @client
          cmd.to_s.should eq "test 1=2"
        end
        @dispatcher.on_player_command(@client, "test 1=2")
      end

      it "parses the command args" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "test" => " (?<arg1>.+)=(?<arg2>.+)" } }
        addon1.should_receive(:on_player_command) do |client, cmd|
          client.should eq @client
          cmd[:arg1].should eq "1"
          cmd[:arg2].should eq "2"
        end
        @dispatcher.on_player_command(@client, "test 1=2")
      end

      it "sends huh message if nobody handles the command" do
        addon1 = PlayerCommandHandlingTestClass.new
        addon1.stub(:commands) { { "x" => "" } }
        @addon_manager.stub(:addons) { [ addon1 ] }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "catches exceptions from within the command handling" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "test" => "" } }
        addon1.stub(:on_player_command).and_raise("an error")
        @client.should_receive(:emit_failure).with("error")
        @dispatcher.on_player_command(@client, "test")
      end
      
      it "allows a addon exit exception to bubble up" do
        addon1 = PlayerCommandHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.stub(:commands) { { "test" => "" } }
        addon1.stub(:on_player_command).and_raise(SystemExit)
        
        expect {@dispatcher.on_player_command(@client, "test")}.to raise_error(SystemExit)
      end
    end

    describe :on_event do
      it "should send the event to any class that handles it" do
        addon1 = ArbitraryEventHandlingTestClass.new
        addon2 = ArbitraryEventHandlingTestClass.new
        @addon_manager.stub(:addons) { [ addon1, addon2 ] }
        args = { :arg1 => "1" }
        addon1.should_receive(:on_arbitrary).with(args)
        addon2.should_receive(:on_arbitrary).with(args)
        @dispatcher.on_event("arbitrary", args)
      end

      it "won't send the event to a class that doesn't handle it" do
        addon1 = Object.new
        @addon_manager.stub(:addons) { [ addon1 ] }
        addon1.should_not_receive(:on_arbitrary)
        @dispatcher.on_event("arbitrary")
      end
    end
  end
end