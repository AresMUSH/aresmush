$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require "ansi"

module AresMUSH

  describe Client do

    describe :next_id do
      it "increments the id with each new client" do
        Client.next_id.should eq 1
        Client.next_id.should eq 2
      end
    end
    
    describe :format_msg do
      it "adds a \n to the end if not already there" do
        msg = Client.format_msg("msg")
        msg.should eq "msg\n"
      end

      it "doesn't add another \n if there's already one on the end" do
        msg = Client.format_msg("msg\n")
        msg.should eq "msg\n"
      end

      it "expands ansi codes" do
        msg = Client.format_msg("my %xcansi%xn message\n")
        msg.should eq "my " + ANSI.cyan + "ansi" + ANSI.reset + " message\n"
      end
    end
    

  end
end