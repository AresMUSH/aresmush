require "aresmush"

def self.plugin_files(name = "*")
  dir = File.join(File.dirname(__FILE__), "*", "**", "*.rb")
  all_files = Dir[dir]  
  all_files.select { |f| !/_spec[s]*.rb*/.match(f) }
end

plugin_files.sort.each do |f|
  load f
end

module AresMUSH
  
  module PluginCmdTestHelper
    include MockClient
    
    attr_accessor :client, :char, :cmd, :handler
    
    def init_handler(handler_class, cmd_text)
      @mock_client = build_mock_client
      @client = @mock_client[:client]
      @char = @mock_client[:char]
      
      @cmd = Command.new(cmd_text)
      
      @handler = handler_class.new
      @handler.client = @client
      @handler.cmd = @cmd
    end  
    
    def reset_char(char)
      @char = char
      @mock_client[:char] = char
      @client.stub(:char) { char }
      @handler.client = @client
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
  
  module ApiHandlerTestHelper
    # let(:expected_cmd) { "cmd name" }
    
    def check_response(response, expected_status, expected_args)
      response.status.should eq expected_status
      response.args_str.should eq expected_args
      response.command_name.should eq expected_cmd
    end
  end 
end
