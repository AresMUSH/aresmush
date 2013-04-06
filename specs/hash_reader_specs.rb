$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

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
    
    
  end
end