$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe MushFormatter do
   def expect_msg(expected, actual)
     actual.should eq expected + ANSI.reset + "\r\n"
   end
   
    describe :format do
      before do
        SubstitutionFormatter.stub(:format) do |msg|
          msg
        end
      end
      
      it "should do MUSH substitutions" do
        SubstitutionFormatter.should_receive(:format).with("msg", true) { "xmsg" }
        msg = MushFormatter.format("msg")
        expect_msg("xmsg", msg)
      end
      
      it "should add an ANSI reset and linebreak to the end" do
        msg = MushFormatter.format("msg")
        expect_msg("msg", msg)
      end

      it "should not add another \n if there's already one on the end" do
        msg = MushFormatter.format("msg\n")
        expect_msg("msg", msg)
      end

      it "should replace an escaped %" do
        msg = MushFormatter.format("A\\%c")
        expect_msg("A%c", msg)
      end
    end
  end
end