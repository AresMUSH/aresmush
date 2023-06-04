

require "aresmush"

module AresMUSH

  describe HashReader do
    it "should provide method accessors for each hash key" do
      hash = 
      {
        "a" => "1",
        "b" => "2"
      }
      reader = HashReader.new(hash)
      expect(reader.a).to eq "1"
      expect(reader.b).to eq "2"
    end
    
    it "should provide method accessors for nested hashes" do
      hash = 
      {
        "a" => 
        {
          "c" => 1,
          "d" => 
          {
            "e" => [1, 2]
          }
        },
        "b" => "2"
      }
      reader = HashReader.new(hash)
      expect(reader.a.c).to eq 1
      expect(reader.a.d.e).to eq [1, 2]
      expect(reader.b).to eq "2"
    end
    
    it "should return nil if the accessor is not found" do
      reader = HashReader.new({"a" => "b"})
      expect(reader.x).to eq nil
    end
    
    describe :raw_hash do
      it "should provide access to the raw hash" do
        hash = {"a" => "b"}
        reader = HashReader.new(hash)
        expect(reader.raw_hash).to eq hash
      end
    end
  end
end
