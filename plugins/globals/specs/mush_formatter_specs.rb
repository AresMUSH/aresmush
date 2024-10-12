

require "aresmush"

module AresMUSH

  describe MushFormatter do
   def expect_msg(expected, actual)
     expect(actual).to eq expected + ANSI.reset + "\r\n"
   end
   
    describe :format do
      before do
        @display_settings = ClientDisplaySettings.new
        allow(SubstitutionFormatter).to receive(:format) do |msg|
          msg
        end
      end
      
      it "should pass along color and screen reader mode options to substitution format" do
        expect(SubstitutionFormatter).to receive(:format).with("msg", @display_settings) { "xmsg" }
        msg = MushFormatter.format("msg", @display_settings)
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
      
      it "should format emojis if enabled" do
        allow(Global).to receive(:read_config).with('emoji', 'allow_emoji') { true }
        allow(EmojiFormatter).to receive(:format).with("ABC") { "ABCEMOJI" }
        msg = MushFormatter.format("ABC")
        expect_msg("ABCEMOJI", msg)
      end
      
      it "should not format emojis in ascii only mode" do
        allow(Global).to receive(:read_config).with('emoji', 'allow_emoji') { true }
        @display_settings.ascii_mode = true
        expect(EmojiFormatter).to_not receive(:format)
        msg = MushFormatter.format("ABC", @display_settings)
        expect_msg("ABC", msg)
      end

      it "should not format emojis in screen reader mode" do
        allow(Global).to receive(:read_config).with('emoji', 'allow_emoji') { true }
        @display_settings.screen_reader = true
        expect(EmojiFormatter).to_not receive(:format)
        msg = MushFormatter.format("ABC", @display_settings)
        expect_msg("ABC", msg)
      end
      
      it "should not format emojis in client doesn't want them" do
        allow(Global).to receive(:read_config).with('emoji', 'allow_emoji') { true }
        @display_settings.emoji_enabled = false
        expect(EmojiFormatter).to_not receive(:format)
        msg = MushFormatter.format("ABC", @display_settings)
        expect_msg("ABC", msg)
      end
      
      it "should not format emojis if disabled" do
        allow(Global).to receive(:read_config).with('emoji', 'allow_emoji') { false }
        expect(EmojiFormatter).to_not receive(:format)
        msg = MushFormatter.format("ABC")
        expect_msg("ABC", msg)
      end
    end
  end
end
