

require "aresmush"

module AresMUSH

  describe Hash do
    
    describe :merge_recursively do
      it "should merge two hashes together" do
        h = { 'a' => { 'b' => 9999, 'c' => "Test" }, "z" => 1 }
        h2 = { 'a' => { 'd' => "Hi there!" }}
        
        merge = h.merge_recursively(h2)
        expect(merge['a']).to include('b' => 9999, 'c' => "Test")
        expect(merge).to include('z' => 1)
      end
    end
    
    describe :merge_recursively! do
      it "should merge two hashes together in place" do
        h = { 'a' => { 'b' => 9999, 'c' => "Test" }, "z" => 1 }
        h2 = { 'a' => { 'd' => "Hi there!" }}
        
        h.merge_recursively!(h2)
        expect(h['a']).to include('b' => 9999, 'c' => "Test")
        expect(h).to include('z' => 1)
      end
    end
    
    describe :has_insensitive_key? do
      it "should match a key" do
        h = { 'a' => "D" }
        expect(h.has_insensitive_key?("A")).to be true
        expect(h.has_insensitive_key?("a")).to be true
      end
      
      it "should not match a missing key" do
        h = { 'a' => "D" }
        expect(h.has_insensitive_key?("x")).to be false
      end     
    end
    
    describe :get_insensitive_key do
      it "should get a key" do
        h = { 'a' => "D" }
        expect(h.get_insensitive_key("A")).to eq "a"
        expect(h.get_insensitive_key("a")).to eq "a"
      end
      
      it "should not get a missing key" do
        h = { 'a' => "D" }
        expect(h.get_insensitive_key("x")).to be_nil
      end     
    end
    
    describe :get_insensitive_value do
      it "should get a key" do
        h = { 'a' => "D" }
        expect(h.get_insensitive_value("A")).to eq "D"
        expect(h.get_insensitive_value("a")).to eq "D"
      end
      
      it "should not get a missing key" do
        h = { 'a' => "D" }
        expect(h.get_insensitive_value("x")).to be_nil
      end     
    end
    
    describe :merge_yaml do
      before do
        @h = {}
        @yaml = {}        
      end
      
      it "should read in the yaml file" do
        expect(YamlExtensions).to receive(:yaml_hash).with("file.yml") { @yaml }
        @h.merge_yaml("file.yml")
      end

      it "should merge in the contents of the yaml" do
        allow(YamlExtensions).to receive(:yaml_hash).with("file.yml") { @yaml }
        expect(@h).to receive(:merge_recursively).with(@yaml)
        @h.merge_yaml("file.yml")
      end
    end
    
    describe :merge_yaml! do
      it "should merge in the contents of the yaml in place" do
        yaml = {}
        h = {}
        allow(YamlExtensions).to receive(:yaml_hash).with("file.yml") { yaml }
        expect(h).to receive(:merge_recursively!).with(yaml)
        h.merge_yaml!("file.yml")
      end
    end
    
    describe :deep_match do
      it "should match if there is a matching key" do
        h = { "abc" => "123" }
        expect(h.deep_match(/b/)).to eq h
      end
      
      it "should match if there is a matching value" do
        h = { "abc" => "123" }
        expect(h.deep_match(/2/)).to eq h
      end
      
      it "should match a sub-hash if there is a matching key" do
        h = { "abc" => {"def" => "123"} }
        expect(h.deep_match(/e/)).to eq h
      end
      
      it "should match a sub-hash if there is a matching value" do
        h = { "abc" => {"def" => "123"} }
        expect(h.deep_match(/2/)).to eq h
      end
      
      it "should not match when nothing suitable is found" do
        h = { "abc" => { "def" => "123"} }
        expect(h.deep_match(/g/)).to be_empty
      end
    end
  end
end
