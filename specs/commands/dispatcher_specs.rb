$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  class ArbitraryEventHandlingTestClass
    def on_arbitrary(args)
    end
  end
  
  describe Dispatcher do
    include GlobalTestHelper

    before do
      stub_global_objects
      @client = double(Client).as_null_object
      @client.stub(:id) { "1" }
      @client.stub(:room) { nil }
      @command = Command.new("x")
      @dispatcher = Dispatcher.new
      @plugin1 = double
      @plugin2 = double
      @plugin1.stub(:log_command)
      @plugin2.stub(:log_command)
      config_reader.stub(:config) { {} }
      SpecHelpers.stub_translate_for_testing
    end

    describe :on_command do
      it "gets the list of plugins from the plugin manager" do
        plugin_manager.should_receive(:plugins) { [] }
        @dispatcher.on_command(@client, @command)
      end
      
      it "asks each plugin if it wants a command" do
        plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.should_receive(:want_command?).with(@client, @command) { false }
        @plugin2.should_receive(:want_command?).with(@client, @command) { false }
        @dispatcher.on_command(@client, @command)
      end
      
      it "won't dispatch to a class that doesn't want the command" do
        plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { false }
        @plugin1.should_not_receive(:on_command) 
        @dispatcher.on_command(@client, @command)
      end

      it "will dispatch to an plugin that wants the command" do
        plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin1.should_receive(:on_command).with(@client, @command)
        @dispatcher.on_command(@client, @command)
      end      
            
      it "stops after finding one plugin to handle the command" do
        plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin2.stub(:want_command?) { true }
        @plugin1.should_receive(:on_command).with(@client, @command)
        @plugin2.should_not_receive(:on_command)
        @dispatcher.on_command(@client, @command)
      end
      
      it "keeps asking plugins if they want the command after an error" do
        plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.stub(:want_command?) { raise }
        @plugin2.stub(:want_command?) { true }
        @plugin2.should_receive(:on_command).with(@client, @command)
        @dispatcher.on_command(@client, @command)
      end
      
      it "continues processing if the first plugin doesn't want the command" do
        plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.stub(:want_command?) { false }
        @plugin2.stub(:want_command?) { true }
        @plugin2.should_receive(:on_command).with(@client, @command)
        @dispatcher.on_command(@client, @command)
      end

      it "sends huh message if nobody handles the command" do
        plugin_manager.stub(:plugins) { [ @plugin1, @plugin2 ] }
        @plugin1.stub(:want_command?) { false }
        @plugin2.stub(:want_command?) { false }
        @client.should_receive(:emit_ooc).with("dispatcher.huh")
        @dispatcher.on_command(@client, @command)
      end      
      
      it "catches exceptions from within the command handling" do
        plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin1.stub(:on_command).and_raise("an error")
        @command.stub(:raw) { "raw" }
        @client.should_receive(:emit_failure).with("dispatcher.error_executing_command")
        @dispatcher.on_command(@client, @command)
      end
      
      it "allows a plugin exit exception to bubble up" do
        plugin_manager.stub(:plugins) { [ @plugin1 ] }
        @plugin1.stub(:want_command?) { true }
        @plugin1.stub(:on_command).and_raise(SystemExit)
        expect {@dispatcher.on_command(@client, @command)}.to raise_error(SystemExit)
      end
    end

    describe :on_event do
      it "should send the event to any class that handles it" do
        plugin1 = ArbitraryEventHandlingTestClass.new
        plugin2 = ArbitraryEventHandlingTestClass.new
        plugin_manager.stub(:plugins) { [ plugin1, plugin2 ] }
        args = { :arg1 => "1" }
        plugin1.should_receive(:on_arbitrary).with(args)
        plugin2.should_receive(:on_arbitrary).with(args)
        @dispatcher.on_event("arbitrary", args)
      end

      it "won't send the event to a class that doesn't handle it" do
        plugin1 = Object.new
        plugin_manager.stub(:plugins) { [ plugin1 ] }
        plugin1.should_not_receive(:on_arbitrary)
        @dispatcher.on_event("arbitrary")
      end
    end
    
    describe :perform_alias_subs do
      before do
        Global.stub(:config) { { "alias" => { "a" => "b", "test" => "c" } } }
      end
        
      it "should substitute roots if the root is an alias" do
        cmd = Command.new("test/foo bar")
        @dispatcher.perform_alias_subs(@client, cmd)
        cmd.root.should eq "c"
        cmd.args.should eq "bar"
        cmd.switch.should eq "foo"
      end
      
      it "should substitute the go command if an exit is matched and there are no args" do
        cmd = Command.new("E")
        room = double
        room.stub(:has_exit?).with("E") { true }
        @client.stub(:room) { room }
        @dispatcher.perform_alias_subs(@client, cmd)
        cmd.root.should eq "go"
        cmd.args.should eq "E"
        cmd.switch.should be_nil
      end
      
      it "should not substitute exit names if there are other args" do
        cmd = Command.new("E foo")
        room = double
        room.stub(:has_exit?).with("E") { true }
        @client.stub(:room) { room }
        @dispatcher.perform_alias_subs(@client, cmd)
        cmd.root.should eq "E"
        cmd.args.should eq "foo"
        cmd.switch.should be_nil
      end
      
    end
  end
end