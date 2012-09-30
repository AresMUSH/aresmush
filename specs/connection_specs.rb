$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Connection do

    describe :format_msg do
      it "adds a \n to the end if not already there" do
        msg = Connection.format_msg("msg")
        msg.should eq "msg\n" + ANSI.reset
      end

      it "doesn't add another \n if there's already one on the end" do
        msg = Connection.format_msg("msg\n")
        msg.should eq "msg\n" + ANSI.reset
      end

      it "expands ansi codes" do
        msg = Connection.format_msg("my %xcansi%xn message\n")
        msg.should eq "my " + ANSI.cyan + "ansi" + ANSI.reset + " message\n" + ANSI.reset
      end
    end

  end
end