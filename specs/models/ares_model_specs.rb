$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  module TestModel
    extend AresModel

    def self.coll
      :test
    end

    def self.custom_model_fields(model)
      model["name_upcase"] = model["name"].upcase
      model
    end
  end

  describe TestModel do
    describe :find do
      it "should return empty if no object found" do
        Database.db.stub(:find) { nil }
        TestModel.find("name" => "Bob").should be_empty
      end

      it "should return a model if found" do
        data = { "name" => "Bob", "password" => "test" }
        Database.db.stub(:find) { [data] }
        TestModel.find("name" => "Bob").should eq [data]
      end

      it "should pass on search params to the db" do
        Database.db.should_receive(:find).with({ "name" => "Bob", "password" => "test" })
        TestModel.find("name" => "Bob", "password" => "test")
      end
    end

    describe :find_by_name do
      it "should pass on the name in uppercase to the other find method" do
        TestModel.should_receive(:find).with("name_upcase" => "BOB")
        TestModel.find_by_name("Bob")
      end
    end

    describe :find_by_location do
      it "should pass the location to the other find method" do
        TestModel.should_receive(:find).with("location" => "LOC")
        TestModel.find_by_location("LOC")
      end
    end

    describe :find_by_id do
      it "should pass on a BSON object id" do
        id = BSON::ObjectId.new([0x4c,0x52,0x8d,0xa0,0x1d,0x41,0xc8,0x5e,0xcf,0x00,0x02,0x11])
        TestModel.should_receive(:find).with("_id" => id)
        TestModel.find_by_id(id)
      end

      it "should wrap a numeric string into a BSON id" do
        TestModel.should_receive(:find).with("_id" => BSON::ObjectId("50a630bbbd02862ead000001"))
        TestModel.find_by_id("50a630bbbd02862ead000001")
      end

      it "should return nothing if given an invalid id" do
        TestModel.find_by_id("id").should eq []
      end
    end

    describe :create do
      before do
        @tmpdb = double(Object)
        Database.db.stub(:[]).with(:test) { @tmpdb }
      end

      it "should create and return the model" do
        @tmpdb.stub(:insert)
        model = TestModel.create("name" => "Bob", "password" => "test")
        model["name"].should eq "Bob"
        model["password"].should eq "test"
      end      

      it "should create the model with extra fields" do
        @tmpdb.stub(:insert)
        model = TestModel.create("name" => "bob", "foo" => "bar")
        model["foo"].should eq "bar"
      end

      it "should set the create date" do
        @tmpdb.stub(:insert)
        date = Time.new
        Time.stub(:now) { date }
        model = TestModel.create("name" => "bob", "foo" => "bar")
        model["create date"].should eq date
      end

      it "should insert the model into the DB" do
        @tmpdb.should_receive(:insert) do |model|
          model["name"].should eq "Bob"
          model["password"].should eq "test"
        end
        TestModel.create("name" => "Bob", "password" => "test")
      end

      it "should call the set fields method" do
        model = {"name" => "Bob", "password" => "test"}
        model2 = double
        @tmpdb.should_receive(:insert) { model }
        TestModel.should_receive(:custom_model_fields).with(model) { model2 }
        TestModel.create(model).should eq model2
      end
    end  

    describe :drop_all do
      it "should drop the database" do
        @tmpdb = double(Object)
        Database.db.stub(:[]).with(:test) { @tmpdb }
        @tmpdb.should_receive(:drop)
        TestModel.drop_all
      end
    end

    describe :update do
      before do
        @tmpdb = double(Object)
        Database.db.stub(:[]).with(:test) { @tmpdb }
      end

      it "should update the model" do
        p = { :_id => "123", "name" => "Bob" }
        AresModel.stub(:id_to_update).with(p) { "123" }
        @tmpdb.should_receive(:update) do |search, model|
          search[:_id].should eq "123"
          model.should eq p
        end
        TestModel.update(p)
      end
    end

    describe :id_to_update do
      it "should find :_id" do
        p = { :_id => "123", "name" => "Bob" }
        TestModel.id_to_update(p).should eq "123"
      end

      it "should find :id" do
        p = { :id => "123", "name" => "Bob" }
        TestModel.id_to_update(p).should eq "123"
      end

      it "should find 'id'" do
        p = { "id" => "123", "name" => "Bob" }
        TestModel.id_to_update(p).should eq "123"
      end

      it "should find '_id'" do
        p = { "_id" => "123", "name" => "Bob" }
        TestModel.id_to_update(p).should eq "123"
      end      
    end

    describe :find_one do
      it "should return nil if there are no items" do
        TestModel.should_receive(:find_by_name_or_id).with("foo") { [] }        
        TestModel.find_one("foo").should be_nil
      end

      it "should return nil if there are more than one item" do
        TestModel.should_receive(:find_by_name_or_id).with("foo") { [double, double] }        
        TestModel.find_one("foo").should be_nil
      end

      it "should return the single item when there is only one" do
        result = double
        TestModel.should_receive(:find_by_name_or_id).with("foo") { [result] }        
        TestModel.find_one("foo").should eq result
      end
    end

    describe :model_class do
      it "should return exit for an exit object" do
        model = { "type" => "Exit" }
        AresModel.model_class(model).should eq Exit
      end

      it "should return char for an char object" do
        model = { "type" => "Character" }
        AresModel.model_class(model).should eq Character
      end

      it "should return room for an room object" do
        model = { "type" => "Room" }
        AresModel.model_class(model).should eq Room
      end

      it "should return nil if there's no type specified" do
        model = { "fpp" => "Exit" }
        AresModel.model_class(model).should eq nil
      end

      it "should return nil if it's not a valid type" do
        model = { "type" => "Foo" }
        AresModel.model_class(model).should eq nil
      end
    end    
  end
end