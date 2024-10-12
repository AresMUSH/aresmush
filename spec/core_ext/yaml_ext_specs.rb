

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
        allow(YAML).to receive(:load) { @yaml }
        expect(File).to receive(:open).with("file.yml") { @io }
        YamlExtensions.yaml_hash("file.yml")
      end
      
      it "should load the YAML from the file" do
        allow(File).to receive(:open).with("file.yml") { @io }
        expect(YAML).to receive(:load).with(@io) { @yaml }
        expect(YamlExtensions.yaml_hash("file.yml")).to eq @yaml
      end
    end
  end
end
