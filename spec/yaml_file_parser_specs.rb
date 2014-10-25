$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe YamlFileParser do

    describe :read do 
     
      it "merges the list of files together with the starting data" do
        data = { 'test' =>  { 'x' => 1 } }
        
        YamlExtensions.should_receive(:yaml_hash).with("a") { { 'test' => { 'a' => 2 } } }
        YamlExtensions.should_receive(:yaml_hash).with("b") { { 'test' => { 'b' => 3 } } }

        data = YamlFileParser.read(["a", "b"], data)
        data['test']['x'].should eq 1
        data['test']['a'].should eq 2
        data['test']['b'].should eq 3
      end
    end
  end
end