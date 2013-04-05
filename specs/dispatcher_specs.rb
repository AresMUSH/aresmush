$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  class ArbitraryEventHandlingTestClass
    def on_arbitrary(args)
    end
  end
  
  describe Dispatcher do

    before do
      @plugin_manager = double(PluginManager)
      @client = double(Client)
      @client.stub(:id) { "1" }
      @command = double(Command)
      @command.stub(:client) { @client }
      @command.stub(:logged_in?) { true }
      @dispatcher = Dispatcher.new(@plugin_manager)
      @plugin1 = Object.new
      @plugin2 = Object.new
      @plugin1.stub(:log_command)
      @plugin2.stub(:log_command)
      AresMUSH::Locale.stub(:translate).with("dispatcher.huh") { "huh" }
      AresMUSH::Locale.stub(:translate).with("dispatcher.error_executing_command", anything()) { "error" }
    end

    describe :on_command do
      it "gets the list of plugins from the plugin manager" do
        @plugin_manager.should_receive(:plugins) { [] }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@client, @command)
      end
      
      it "asks each plugin if it wants a command when the char is logged in" do
        @plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.should_receive(:want_command?).with(@command) { false }
        @plugin2.should_receive(:want_command?).with(@command) { false }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@client, @command)
      end
      
      it "asks each plugin if it wants a command when the char is not logged in" do
        @command.stub(:logged_in?) { false }
        @plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.should_receive(:want_anon_command?).with(@command) { false }
        @plugin2.should_receive(:want_anon_command?).with(@command) { false }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@client, @command)
      end
      
      it "won't dispatch to a class that doesn't want the command" do
        @plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { false }
        @plugin1.should_not_receive(:on_command) 
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@client, @command)
      end
      
      it "will dispatch to an plugin that wants the command" do
        @plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin1.should_receive(:on_command).with(@client, @command)
        @dispatcher.on_command(@client, @command)
      end
      
      it "will log the command for an plugin that wants the command" do
        @plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin1.should_receive(:log_command).with(@client, @command)
        @dispatcher.on_command(@client, @command)
      end
      
      it "will dispatch to a plugin that wants an anon command" do
        @command.stub(:logged_in?) { false }
        @plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_anon_command?) { true }
        @plugin1.should_receive(:on_command).with(@client, @command)
        @dispatcher.on_command(@client, @command)
      end
            
      it "stops after finding one plugin to handle the command" do
        @plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin2.stub(:want_command?) { true }
        @plugin1.should_receive(:on_command).with(@client, @command)
        @plugin2.should_not_receive(:on_command)
        @dispatcher.on_command(@client, @command)
      end
      
      it "continues processing if the first plugin doesn't want the command" do
        @plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.stub(:want_command?) { false }
        @plugin2.stub(:want_command?) { true }
        @plugin2.should_receive(:on_command).with(@client, @command)
        @dispatcher.on_command(@client, @command)
      end

      it "sends huh message if nobody handles the command" do
        @plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.stub(:want_command?) { false }
        @plugin2.stub(:want_command?) { false }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.on_command(@client, @command)
      end      
      
      it "catches exceptions from within the command handling" do
        @plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin1.stub(:on_command).and_raise("an error")
        @command.stub(:raw) { "raw" }
        @client.should_receive(:emit_failure).with("error")
        @dispatcher.on_command(@client, @command)
      end
      
      it "allows a plugin exit exception to bubble up" do
        @plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin1.stub(:on_command).and_raise(SystemExit)
        expect {@dispatcher.on_command(@client, @command)}.to raise_error(SystemExit)
      end
    end

    describe :on_event do
      it "should send the event to any class that handles it" do
        plugin1 = ArbitraryEventHandlingTestClass.new
        plugin2 = ArbitraryEventHandlingTestClass.new
        @plugin_manager.stub(:plugins) { [ plugin1, plugin2 ] }
        args = { :arg1 => "1" }
        plugin1.should_receive(:on_arbitrary).with(args)
        plugin2.should_receive(:on_arbitrary).with(args)
        @dispatcher.on_event("arbitrary", args)
      end

      it "won't send the event to a class that doesn't handle it" do
        plugin1 = Object.new
        @plugin_manager.stub(:plugins) { [ plugin1 ] }
        plugin1.should_not_receive(:on_arbitrary)
        @dispatcher.on_event("arbitrary")
      end
    end
  end
end