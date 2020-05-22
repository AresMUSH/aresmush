$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe EmojiFormatter do
    before do
      emoji = { 
        'cowboy' => '1F920', 
        'rocket_ship' => '1F680',
        'smile' =>  '1F600',
        'frown' => '1F626',
        'red_heart' => '2764'
      }
      allow(Global).to receive(:read_config).with('emoji', 'emoji') { emoji }
      allow(Global).to receive(:read_config).with('emoji', 'smileys') { { ':)' => 'smile', ':(' => 'frown' } }
      allow(Global).to receive(:read_config).with('emoji', 'aliases') { { 'rocket' => 'rocket_ship' } }
    end
    
    describe :format do
      it "should format a found emoji" do
        msg = EmojiFormatter.format("I want to be a :cowboy: on the range.")
        expect(msg).to eq "I want to be a \u{1F920} on the range."
      end
      
      it "should format a multi-word emoji" do
        msg = EmojiFormatter.format("I want to fly in a :rocket_ship:.")
        expect(msg).to eq "I want to fly in a \u{1F680}."
      end
      
      it "should format multiple emoji in one message" do
        msg = EmojiFormatter.format("I want to fly in a :rocket_ship: with a :cowboy:.")
        expect(msg).to eq "I want to fly in a \u{1F680} with a \u{1F920}."
      end
      
      it "should ignore an emoji that isn't found" do
        msg = EmojiFormatter.format("I want to fly to :mars:.")
        expect(msg).to eq "I want to fly to :mars:."
      end

      it "should work with mixed case" do
        msg = EmojiFormatter.format("I want to fly in a :ROCKET_ship:.")
        expect(msg).to eq "I want to fly in a \u{1F680}."
      end
      
      it "should replace a smiley" do
        msg = EmojiFormatter.format("I want to fly in a :rocket_ship: :).")
        expect(msg).to eq "I want to fly in a \u{1F680} \u{1F600}."
      end
      
      it "should replace multiple smileys" do
        msg = EmojiFormatter.format("I want to fly in a :rocket_ship: :) but I can't :(.")
        expect(msg).to eq "I want to fly in a \u{1F680} \u{1F600} but I can't \u{1F626}."
      end
      
      it "should replace an alias" do
        msg = EmojiFormatter.format("I want to fly in a :rocket:.")
        expect(msg).to eq "I want to fly in a \u{1F680}."
      end
      
      it "should not replace smiley in the middle of another word." do
        msg = EmojiFormatter.format("I want to fly yes:)so.")
        expect(msg).to eq "I want to fly yes:)so."
      end
      
      it "should not replace a link." do
        msg = EmojiFormatter.format("I want go to https://google.com.")
        expect(msg).to eq "I want go to https://google.com."
      end
      
      it "should replace smiley by itself." do
        msg = EmojiFormatter.format(":)")
        expect(msg).to eq "\u{1F600}"
      end
      
      it "should replace two smileys in a row." do
        msg = EmojiFormatter.format("Test :) :(")
        expect(msg).to eq "Test \u{1F600} \u{1F626}"
      end
      
      it "should replace a smiley at the end of a quote." do
        msg = EmojiFormatter.format("Faraday says, \"Test :)\"")
        expect(msg).to eq "Faraday says, \"Test \u{1F600}\""
      end
      
      it "should not replace a code-block emoji" do
        msg = EmojiFormatter.format("This is my `:rocket:`")
        expect(msg).to eq "This is my `:rocket:`"
      end
      
      it "should format the silly black heart" do
        msg = EmojiFormatter.format("I have a :red_heart: and I don't want it painted black.")
        expect(msg).to eq "I have a \u2764\uFE0F and I don't want it painted black."
      end
      
      it "should format three smileys in a row" do
        msg = EmojiFormatter.format("Ha ha :) :) :)")
        expect(msg).to eq "Ha ha \u{1F600} \u{1F600} \u{1F600}"
      end
      
    end
  end
end
