

require "aresmush"

module AresMUSH
  describe CommandAliasParser do
    before do
      @enactor = double
      allow(@enactor).to receive(:room) { nil }
      @shortcuts =
      {
        "a" => "b", 
        "c" => "d" ,
        "b/c" => "d/e", 
        "b/d" => "f", 
        "e" => "f/g",
        "m" => "n/o foo"
      }
      allow(@enactor).to receive(:shortcuts) { {} }
      stub_translate_for_testing
    end
    
    describe :substitute_aliases do

      it "should substitute enactor shortcuts" do
        cmd = Command.new("foo bar")
        allow(@enactor).to receive(:shortcuts) { { "foo" => "help" }}
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "help"
        expect(cmd.args).to eq "bar"
      end
            
      it "should substitute roots if the root is an alias" do
        cmd = Command.new("c/foo bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "d"
        expect(cmd.switch).to eq "foo"
        expect(cmd.args).to eq "bar"
      end
          
      it "should NOT substitute roots if only part of the root is an alias" do
        cmd = Command.new("cab bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "cab"
        expect(cmd.switch).to be_nil
        expect(cmd.args).to eq "bar"
      end
      
      it "should substitute the go command if an exit is matched and there are no args" do
        cmd = Command.new("E")
        room = double
        allow(room).to receive(:has_exit?).with("E") { true }
        allow(@enactor).to receive(:room) { room }
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "go"
        expect(cmd.args).to eq "E"
        expect(cmd.switch).to be_nil
      end
      
      it "should substitute the go command if an exit with a number is matched" do
        cmd = Command.new("E1")
        room = double
        allow(room).to receive(:has_exit?).with("E1") { true }
        allow(@enactor).to receive(:room) { room }
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "go"
        expect(cmd.args).to eq "E1"
        expect(cmd.switch).to be_nil
      end
      
      it "should not substitute exit names if there are other args" do
        cmd = Command.new("X foo")
        room = double
        allow(room).to receive(:has_exit?).with("x") { true }
        allow(@enactor).to receive(:room) { room }
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "x"
        expect(cmd.args).to eq "foo"
        expect(cmd.switch).to be_nil
      end
      
      it "should substitute a switch to a single command" do
        cmd = Command.new("b/d xyz")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "f"
        expect(cmd.switch).to be_nil
        expect(cmd.args).to eq "xyz"
      end
      
      it "should substitute a single command to a switch" do
        cmd = Command.new("e xyz")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "f"
        expect(cmd.switch).to eq "g"
        expect(cmd.args).to eq "xyz"
      end
      
      it "should double substitute both a root and a switch" do
        cmd = Command.new("a/c xyz")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "d"
        expect(cmd.switch).to eq "e"
        expect(cmd.args).to eq "xyz"
      end
          
      it "should NOT substitute a partial match on a switch" do
        cmd = Command.new("b/ccc foo")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "b"
        expect(cmd.switch).to eq "ccc"
        expect(cmd.args).to eq "foo"
      end
      
      it "should substitute a full commmand with args" do
        cmd = Command.new("m bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "n"
        expect(cmd.switch).to eq "o"
        expect(cmd.args).to eq "foo bar"
      end
          
      it "should substitute even with a prefix" do
        cmd = Command.new("+m bar")
        CommandAliasParser.substitute_aliases(@enactor, cmd, @shortcuts)
        expect(cmd.root).to eq "n"
        expect(cmd.switch).to eq "o"
        expect(cmd.args).to eq "foo bar"
      end
      
    end
  end
end
