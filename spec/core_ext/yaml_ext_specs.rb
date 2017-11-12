$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe YamlExtensions do
    
    describe :yaml_hash do
      before do
         @io = double(IO)        
         @h = {}
         @yaml = {}        
      end
      
      it "should read in the contents of the file" do
        YAML.stub(:load) { @yaml }
        File.should_receive(:open).with("file.yml") { @io }
        YamlExtensions.yaml_hash("file.yml")
      end
      
      it "should load the YAML from the file" do
        File.stub(:open).with("file.yml") { @io }
        YAML.should_receive(:load).with(@io) { @yaml }
        YamlExtensions.yaml_hash("file.yml").should eq @yaml
      end
    end
  end
end