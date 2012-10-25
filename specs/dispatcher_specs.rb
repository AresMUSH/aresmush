$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  describe Client do

    before do
      @system_manager = double(SystemManager)
      @client = double(Client).as_null_object
      @dispatcher = Dispatcher.new(@system_manager)
      AresMUSH::Locale.stub(:translate).with("huh") { "huh" }
    end

    describe :dispatch do

      it "gets the list of systems from the system manager" do
        @system_manager.should_receive(:systems) { [] }
        @dispatcher.dispatch(@client, "test")
      end

      it "asks each system for its commands" do
        system1 = Object.new
        system2 = Object.new
        @system_manager.stub(:systems) { [ system1, system2 ] }
        system1.should_receive(:commands) { [] }
        system2.should_receive(:commands) { [] }
        @dispatcher.dispatch(@client, "test")
      end

      it "calls handle on any system that matches the regex" do
        system1 = Object.new
        system2 = Object.new
        system3 = Object.new
        @system_manager.stub(:systems) { [ system1, system2, system3 ] }
        system1.stub(:commands) { ["test"] }
        system2.stub(:commands) { ["x", "test"] }
        system3.stub(:commands) { ["foo"] }
        system1.should_receive(:handle).with(@client, an_instance_of(MatchData))
        system2.should_receive(:handle).with(@client, an_instance_of(MatchData))
        @dispatcher.dispatch(@client, "test")
      end
      
      it "passes along the command" do
        system1 = Object.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.stub(:commands) { ["test .+"] }
        system1.should_receive(:handle) do |client, cmd|
          client.should eq @client
          cmd.should eq "test 1=2"
        end
        @dispatcher.dispatch(@client, "test 1=2")
      end

      it "parses the command args" do
        system1 = Object.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.stub(:commands) { ["test (?<arg1>.+)=(?<arg2>.+)"] }
        system1.should_receive(:handle) do |client, cmd|
          client.should eq @client
          cmd[:arg1].should eq "1"
          cmd[:arg2].should eq "2"
        end
        @dispatcher.dispatch(@client, "test 1=2")
      end

      it "sends huh message if nobody handles the command" do
        system1 = Object.new
        system1.stub(:commands) { ["x"] }
        @system_manager.stub(:systems) { [ system1 ] }
        @client.should_receive(:emit_ooc).with("huh")
        @dispatcher.dispatch(@client, "test")
      end
      
      it "catches exceptions from within the command handling" do
        system1 = Object.new
        @system_manager.stub(:systems) { [ system1 ] }
        system1.stub(:commands) { ["test"] }
        system1.stub(:handle).and_raise("an error")
        # TODO - fix message, translate
        @client.should_receive(:emit_failure).with("Bad code did badness! an error")
        @dispatcher.dispatch(@client, "test")
      end
    end


  end
end