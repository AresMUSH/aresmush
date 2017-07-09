$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe CommandAliasParser do
    before do
      @enactor = double
      @enactor.stub(:room) { nil }
      @shortcuts =
      {
        "a" => "b", 
        "c" => "d" ,
        "b/c" => "d/e", 
        "b/d" => "f", 
        "e" => "f/g",
        "m" => "n/o foo"
      }
      @enactor.stub(:shortcuts) { {} }
      SpecHelpers.stub_translate_for_testing
    end
    
    describe :substitute_aliases do

      it "should substitute enactor shortcuts" do
        cmd = Command.new("foo bar")
        @enactor.stub(:shortcuts) { { "foo" => "help" }}
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "help"
        cmd.args.should eq "bar"
      end
            
      it "should substitute roots if the root is an alias" do
        cmd = Command.new("c/foo bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "d"
        cmd.switch.should eq "foo"
        cmd.args.should eq "bar"
      end
          
      it "should NOT substitute roots if only part of the root is an alias" do
        cmd = Command.new("cab bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "cab"
        cmd.switch.should be_nil
        cmd.args.should eq "bar"
      end
      
      it "should substitute the go command if an exit is matched and there are no args" do
        cmd = Command.new("E")
        room = double
        room.stub(:has_exit?).with("e") { true }
        @enactor.stub(:room) { room }
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "go"
        cmd.args.should eq "e"
        cmd.switch.should be_nil
      end
      
      it "should not substitute exit names if there are other args" do
        cmd = Command.new("X foo")
        room = double
        room.stub(:has_exit?).with("x") { true }
        @enactor.stub(:room) { room }
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "x"
        cmd.args.should eq "foo"
        cmd.switch.should be_nil
      end
      
      it "should substitute a switch to a single command" do
        cmd = Command.new("b/d xyz")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "f"
        cmd.switch.should be_nil
        cmd.args.should eq "xyz"
      end
      
      it "should substitute a single command to a switch" do
        cmd = Command.new("e xyz")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "f"
        cmd.switch.should eq "g"
        cmd.args.should eq "xyz"
      end
      
      it "should double substitute both a root and a switch" do
        cmd = Command.new("a/c xyz")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "d"
        cmd.switch.should eq "e"
        cmd.args.should eq "xyz"
      end
          
      it "should NOT substitute a partial match on a switch" do
        cmd = Command.new("b/ccc foo")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "b"
        cmd.switch.should eq "ccc"
        cmd.args.should eq "foo"
      end
      
      it "should substitute a full commmand with args" do
        cmd = Command.new("m bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "n"
        cmd.switch.should eq "o"
        cmd.args.should eq "foo bar"
      end
          
      it "should substitute even with a prefix" do
        cmd = Command.new("+m bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        cmd.root.should eq "n"
        cmd.switch.should eq "o"
        cmd.args.should eq "foo bar"
      end
      
    end
  end
end