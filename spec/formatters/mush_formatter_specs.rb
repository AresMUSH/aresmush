$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe MushFormatter do
   def expect_msg(expected, actual)
     expect(actual).to eq expected + ANSI.reset + "\r\n"
   end
   
    describe :format do
      before do
        allow(SubstitutionFormatter).to receive(:format) do |msg|
          msg
        end
      end
      
      it "should do MUSH substitutions" do
        expect(SubstitutionFormatter).to receive(:format).with("msg", "FANSI", false) { "xmsg" }
        msg = MushFormatter.format("msg")
        expect_msg("xmsg", msg)
      end
      
      it "should pass along color and screen reader mode options to substitution format" do
        expect(SubstitutionFormatter).to receive(:format).with("msg", "ANSI", true) { "xmsg" }
        msg = MushFormatter.format("msg", "ANSI", true)
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
