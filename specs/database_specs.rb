$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Database do
    describe :connect do
      
      before do
        db_config = 
        {
            'host' => 'host',
            'port' => 123,
            'database' => 'ares',
            'username' => 'user',
            'password' => 'pw'
        }
        Global.stub(:config) { {'database' => db_config } }
        @db = Database.new
      end
      
      it "should connect on the configured host and port" do
        connection = double(Mongo::Connection).as_null_object
        Mongo::Connection.should_receive(:new).with('host', 123) { connection }
        @db.connect
      end

      it "should authenticate using the configured username and password" do
        connection = double(Mongo::Connection).as_null_object
        Mongo::Connection.stub(:new).with('host', 123) { connection }
        connection.should_receive(:authenticate).with('user', 'pw')
        @db.connect
      end
      
      it "should raise an error if authentication fails" do
        connection = double(Mongo::Connection).as_null_object
        Mongo::Connection.stub(:new).with('host', 123) { connection }
        connection.stub(:authenticate).with('user', 'pw') { false }
        expect{@db.connect}.to raise_error(StandardError)
      end
      
      it "should pick the configured database" do
        connection = double(Mongo::Connection).as_null_object
        Mongo::Connection.stub(:new).with('host', 123) { connection }
        connection.should_receive(:db).with('ares')
        @db.connect
      end
    end
  end
end