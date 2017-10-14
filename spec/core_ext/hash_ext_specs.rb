$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe Hash do
    
    describe :merge_recursively do
      it "should merge two hashes together" do
        h = { 'a' => { 'b' => 9999, 'c' => "Test" }, "z" => 1 }
        h2 = { 'a' => { 'd' => "Hi there!" }}
        
        merge = h.merge_recursively(h2)
        merge['a'].should include('b' => 9999, 'c' => "Test")
        merge.should include('z' => 1)
      end
    end
    
    describe :merge_recursively! do
      it "should merge two hashes together in place" do
        h = { 'a' => { 'b' => 9999, 'c' => "Test" }, "z" => 1 }
        h2 = { 'a' => { 'd' => "Hi there!" }}
        
        h.merge_recursively!(h2)
        h['a'].should include('b' => 9999, 'c' => "Test")
        h.should include('z' => 1)
      end
    end
    
    describe :has_insensitive_key? do
      it "should match a key" do
        h = { 'a' => "D" }
        h.has_insensitive_key?("A").should be true
        h.has_insensitive_key?("a").should be true
      end
      
      it "should not match a missing key" do
        h = { 'a' => "D" }
        h.has_insensitive_key?("x").should be false
      end     
    end
    
    describe :get_insensitive_key do
      it "should get a key" do
        h = { 'a' => "D" }
        h.get_insensitive_key("A").should eq "a"
        h.get_insensitive_key("a").should eq "a"
      end
      
      it "should not get a missing key" do
        h = { 'a' => "D" }
        h.get_insensitive_key("x").should be_nil
      end     
    end
    
    describe :get_insensitive_value do
      it "should get a key" do
        h = { 'a' => "D" }
        h.get_insensitive_value("A").should eq "D"
        h.get_insensitive_value("a").should eq "D"
      end
      
      it "should not get a missing key" do
        h = { 'a' => "D" }
        h.get_insensitive_value("x").should be_nil
      end     
    end
    
    describe :merge_yaml do
      before do
        @h = {}
        @yaml = {}        
      end
      
      it "should read in the yaml file" do
        YamlExtensions.should_receive(:yaml_hash).with("file.yml") { @yaml }
        @h.merge_yaml("file.yml")
      end

      it "should merge in the contents of the yaml" do
        YamlExtensions.stub(:yaml_hash).with("file.yml") { @yaml }
        @h.should_receive(:merge_recursively).with(@yaml)
        @h.merge_yaml("file.yml")
      end
    end
    
    describe :merge_yaml! do
      it "should merge in the contents of the yaml in place" do
        yaml = {}
        h = {}
        YamlExtensions.stub(:yaml_hash).with("file.yml") { yaml }
        h.should_receive(:merge_recursively!).with(yaml)
        h.merge_yaml!("file.yml")
      end
    end
    
    describe :deep_match do
      it "should match if there is a matching key" do
        h = { "abc" => "123" }
        h.deep_match(/b/).should eq h
      end
      
      it "should match if there is a matching value" do
        h = { "abc" => "123" }
        h.deep_match(/2/).should eq h
      end
      
      it "should match a sub-hash if there is a matching key" do
        h = { "abc" => {"def" => "123"} }
        h.deep_match(/e/).should eq h
      end
      
      it "should match a sub-hash if there is a matching value" do
        h = { "abc" => {"def" => "123"} }
        h.deep_match(/2/).should eq h
      end
      
      it "should not match when nothing suitable is found" do
        h = { "abc" => { "def" => "123"} }
        h.deep_match(/g/).should be_empty
      end
    end
  end
end