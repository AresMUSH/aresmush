$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe YamlExtensions do
    before do
      @temp_dir = "#{Dir.pwd}/tmp_yaml"
      create_temp_files
      @yaml = YamlExtensions.one_yaml_to_rule_them_all(@temp_dir)
    end

    after do
      FileUtils.rm_rf @temp_dir
    end
    
    describe :one_yaml_to_rule_them_all do
      it "should include the contents of the yaml file" do
        @yaml['a'].should include('b' => 9999, 'c' => "Test")
        @yaml.should include('z' => 1)
      end

      it "should include the contents of the yaml file" do
        @yaml['a'].should include('d' => "Hi there!")
      end

      it "should skip non-yaml files" do
        @yaml['a'].should_not include('e')
      end

      def create_temp_files
        FileUtils.rm_rf @temp_dir
        Dir.mkdir @temp_dir

        y1 = { 'a' => { 'b' => 9999, 'c' => "Test" }, "z" => 1 }
        write_yaml_file("test1.yml", y1)

        y2 = { 'a' => { 'd' => "Hi there!" }}
        write_yaml_file("test2.yaml", y2)

        y3 = { 'a' => { 'e' => "Shouldn't find me." }}
        write_yaml_file("test3.txt", y3)
      end

      def write_yaml_file(filename, contents)
        File.open("#{@temp_dir}/#{filename}", "w") do |f|
          f.write(contents.to_yaml)
        end
      end          
    end
  end
end