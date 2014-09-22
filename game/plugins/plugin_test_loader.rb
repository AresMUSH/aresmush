require "aresmush"

def self.plugin_files(name = "*")
  dir = File.join(File.dirname(__FILE__), "*", "**", "*.rb")
  all_files = Dir[dir]  
  all_files.select { |f| !/_spec[s]*.rb*/.match(f) }
end

plugin_files.each do |f|
  load f
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.include AresMUSH::SpecHelpers
end

module AresMUSH
  module PluginSystemTest
    include GameTestHelper
    include GlobalTestHelper
    
    attr_accessor :client, :char, :handler

    def init_handler(handler_class)
      @handler = handler_class.new
      SpecHelpers.stub_translate_for_testing  
      stub_global_objects
      stub_game_master      
      setup_client_with_mock_char
    end
    
    def setup_client_with_mock_char
      @client = double
      @char = double
      @char.stub(:name) { "TestDummy" }
      @client.stub(:char) { @char }
      @client.stub(:name) { "TestDummy" }
    end
    
    def setup_client_with_real_char
      @client = double
      @char = Character.create(name: "TestDummy")
      @client.stub(:char) { @char }
      @client.stub(:name) { "TestDummy" }
    end
    
    shared_context "setup test db", :dbtest do
      before do
        stub_client_reload
        SpecHelpers.connect_to_test_db
        game.stub(:welcome_room) { nil }
      end
      
      after do
        SpecHelpers.erase_test_db
      end
    end
    
    shared_examples "a plugin that fails if not logged in" do
      it "should fail if not logged in" do
        client.stub(:logged_in?) { false }
        client.should_receive(:emit_failure).with('dispatcher.must_be_logged_in')
        handler.on_command client, Command.new("")
      end
    end
    
    shared_examples "a plugin that only accepts certain roots and switches" do
      # let(:wanted_cmds) { [ "root1", "root2", "root1/switch1", "root1/switch2" ] }
      
      describe :want_command do
        it "should  accept valid roots and switches" do
          wanted_cmds.each do |wanted|
            handler.want_command?(client, Command.new(wanted)).should be_true
          end
        end
      
        it "should reject a different root" do
          handler.want_command?(client, Command.new("somethingelse here")).should be_false
        end
      
        it "should reject a different switch" do
          not_wanted = wanted_cmds[0] =~ /\// ? "#{wanted_cmds[0]}unrecognized" : "#{wanted_cmds[0]/unrecognized}"
          handler.want_command?(client, Command.new("somethingelse here")).should be_false
        end
      end
    end
  end
  
  module PluginCmdTestHelper
    include MockClient
    
    attr_accessor :client, :char, :cmd, :handler
    
    def init_handler(handler_class, cmd_text)
      mock_client = build_mock_client
      @client = mock_client[:client]
      @char = mock_client[:char]
      
      @cmd = Command.new(cmd_text)
      
      @handler = handler_class.new
      @handler.client = @client
      @handler.cmd = @cmd
    end  
        
    shared_examples "a plugin that expects a single root" do
      # let(:expected_root) { "cmd name" }
      describe :want_command? do
        it "wants the expected command" do
          cmd.stub(:root_is?).with(expected_root) { true }
          handler.want_command?(client, cmd).should be_true
        end

        it "doesn't want another command" do
          cmd.stub(:root_is?).with(expected_root) { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
    end

    shared_examples "a plugin that expects a single root and switch" do
      # let(:expected_root) { "cmd name" }
      # let(:expected_switch) { "cmd switch" }
      describe :want_command? do
        it "wants the expected command with its appropriate switch" do
          cmd.stub(:root_is?).with(expected_root) { true }
          cmd.stub(:switch) { expected_switch }
          handler.want_command?(client, cmd).should be_true
        end

        it "doesn't want another command" do
          cmd.stub(:root_is?).with(expected_root) { false }
          cmd.stub(:switch) { expected_switch }
          handler.want_command?(client, cmd).should be_false
        end

        it "doesn't want another switch" do
          cmd.stub(:root_is?).with(expected_root) { true }
          cmd.stub(:switch) { "#{expected_switch} something else" }
          handler.want_command?(client, cmd).should be_false
        end
      end
    end
    
    shared_examples "a plugin that doesn't allow switches" do
      it "should include the no switch validator" do
        handler.methods.should include :check_2_no_switches
      end
    end

    shared_examples "a plugin that doesn't allow args" do
      it "should include the no switch validator" do
        handler.methods.should include :check_2_no_args
      end
    end
      
    shared_examples "a plugin that requires login" do
      it "should include the login validator" do
        handler.methods.should include :check_1_for_login
      end
    end
  end  
end
