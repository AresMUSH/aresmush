$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe CommandAliasParser do
    before do
      @client = double(Client)
      @client.stub(:room) { nil }
      Global.stub(:config) { { 
        "shortcuts" =>
        {
          "roots" => 
          {
            "a" => "b", 
            "c" => "d" 
          },
          "full" => 
          { 
            "b/c" => "d/e", 
            "b/d" => "f", 
            "e" => "f/g"
          } 
          } } }
          SpecHelpers.stub_translate_for_testing
        end
    
        describe :substitute_aliases do
      
          it "should substitute roots if the root is an alias" do
            cmd = Command.new("c/foo bar")
            CommandAliasParser.substitute_aliases(@client, cmd)
            cmd.root.should eq "d"
            cmd.switch.should eq "foo"
            cmd.args.should eq "bar"
          end
          
          it "should NOT substitute roots if only part of the root is an alias" do
            cmd = Command.new("cab bar")
            CommandAliasParser.substitute_aliases(@client, cmd)
            cmd.root.should eq "cab"
            cmd.switch.should be_nil
            cmd.args.should eq "bar"
          end
      
          it "should substitute the go command if an exit is matched and there are no args" do
            cmd = Command.new("E")
            room = double
            room.stub(:has_exit?).with("E") { true }
            @client.stub(:room) { room }
            CommandAliasParser.substitute_aliases(@client, cmd)
            cmd.root.should eq "go"
            cmd.args.should eq "E"
            cmd.switch.should be_nil
          end
      
          it "should not substitute exit names if there are other args" do
            cmd = Command.new("X foo")
            room = double
            room.stub(:has_exit?).with("X") { true }
            @client.stub(:room) { room }
            CommandAliasParser.substitute_aliases(@client, cmd)
            cmd.root.should eq "X"
            cmd.args.should eq "foo"
            cmd.switch.should be_nil
          end
      
          it "should substitute a switch to a single command" do
            cmd = Command.new("b/d xyz")
            CommandAliasParser.substitute_aliases(@client, cmd)
            cmd.root.should eq "f"
            cmd.switch.should be_nil
            cmd.args.should eq "xyz"
          end
      
          it "should substitute a single command to a switch" do
            cmd = Command.new("e xyz")
            CommandAliasParser.substitute_aliases(@client, cmd)
            cmd.root.should eq "f"
            cmd.switch.should eq "g"
            cmd.args.should eq "xyz"
          end
      
          it "should double substitute both a root and a switch" do
            cmd = Command.new("a/c xyz")
            CommandAliasParser.substitute_aliases(@client, cmd)
            cmd.root.should eq "d"
            cmd.switch.should eq "e"
            cmd.args.should eq "xyz"
          end
      
        end
      end
    end