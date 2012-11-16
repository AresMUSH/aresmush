$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  class ArbitraryEventHandlingTestClass
    def on_arbitrary(args)
    end
  end
  
  describe Client do

    before do
      @addon_manager = double(AddonManager)
      @client = double(Client)
      @command = double(Command)
      @command.stub(:client) { @client }
      @dispatcher = Dispatcher.new(@addon_manager)
      @addon1 = Object.new
      @addon2 = Object.new
      AresMUSH::Locale.stub(:translate).with("dispatcher.huh") { "huh" }
      AresMUSH::Locale.stub(:translate).with("dispatcher.error_executing_command", anything()) { "error" }
    end

    describe :on_command do
      it "gets the list of addons from the addon manager" do
        @addon_manager.should_receive(:addons) { [] }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@command)
      end
      
      it "asks each addon if it wants the command" do
        @addon_manager.stub(:addons) { [ @addon1, @addon2 ] }
        @addon1.should_receive(:want_command?).with(@command) { false }
        @addon2.should_receive(:want_command?).with(@command) { false }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@command)
      end      
      
      it "won't dispatch to a class that doesn't want the command" do
        @addon_manager.stub(:addons) { [ @addon1 ] }
        @addon1.stub(:want_command?) { false }
        @addon1.should_not_receive(:on_command) 
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@command)
      end
      
      it "will dispatch to an addon that wants the command" do
        @addon_manager.stub(:addons) { [ @addon1 ] }
        @addon1.stub(:want_command?) { true }
        @addon1.should_receive(:on_command).with(@command)
        @dispatcher.on_command(@command)
      end
            
      it "stops after finding one addon to handle the command" do
        @addon_manager.stub(:addons) { [ @addon1, @addon2 ] }
        @addon1.stub(:want_command?) { true }
        @addon2.stub(:want_command?) { true }
        @addon1.should_receive(:on_command).with(@command)
        @addon2.should_not_receive(:on_command).with(@command)
        @dispatcher.on_command(@command)
      end
      
      it "continues processing if the first addon doesn't want the command" do
        @addon_manager.stub(:addons) { [ @addon1, @addon2 ] }
        @addon1.stub(:want_command?) { false }
        @addon2.stub(:want_command?) { true }
        @addon2.should_receive(:on_command).with(@command)
        @dispatcher.on_command(@command)
      end

      it "sends huh message if nobody handles the command" do
        @addon_manager.stub(:addons) { [ @addon1, @addon2 ] }
        @addon1.stub(:want_command?) { false }
        @addon2.stub(:want_command?) { false }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@command)
      end      
      
      it "catches exceptions from within the command handling" do
        @addon_manager.stub(:addons) { [ @addon1 ] }
        @addon1.stub(:want_command?) { true }
        @addon1.stub(:on_command).and_raise("an error")
        @command.stub(:raw) { "raw" }
        @client.should_receive(:emit_failure).with("error")
        @dispatcher.on_command(@command)
      end
      
      it "allows a addon exit exception to bubble up" do
        @addon_manager.stub(:addons) { [ @addon1 ] }
        @addon1.stub(:want_command?) { true }
        @addon1.stub(:on_command).and_raise(SystemExit)
        expect {@dispatcher.on_command(@command)}.to raise_error(SystemExit)
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