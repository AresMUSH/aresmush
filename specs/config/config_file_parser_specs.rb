$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe ConfigFileParser do

    describe :read do 
     
      it "merges the list of files together with the starting config" do
        config = { 'test' =>  { 'x' => 1 } }
        
        YamlExtensions.should_receive(:yaml_hash).with("a") { { 'test' => { 'a' => 2 } } }
        YamlExtensions.should_receive(:yaml_hash).with("b") { { 'test' => { 'b' => 3 } } }

        config = ConfigFileParser.read(["a", "b"], config)
        config['test']['x'].should eq 1
        config['test']['a'].should eq 2
        config['test']['b'].should eq 3
      end
    end
  end
end