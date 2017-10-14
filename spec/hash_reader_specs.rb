$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

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
      reader.a.should eq "1"
      reader.b.should eq "2"
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
      reader.a.c.should eq 1
      reader.a.d.e.should eq [1, 2]
      reader.b.should eq "2"
    end
    
    it "should return nil if the accessor is not found" do
      reader = HashReader.new({"a" => "b"})
      reader.x.should eq nil
    end
    
    describe :raw_hash do
      it "should provide access to the raw hash" do
        hash = {"a" => "b"}
        reader = HashReader.new(hash)
        reader.raw_hash.should eq hash
      end
    end
  end
end