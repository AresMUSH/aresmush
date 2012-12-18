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
    
    describe :find_by_id do
      it "should pass on a BSON object id" do
        id = BSON::ObjectId.new("123")
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
        TestModel.create("name" => "Bob", "password" => "test") do |model|
          model["name"].should eq "Bob"
          model["password"].should eq "test"
        end        
      end      
      
      it "should create the model with extra fields" do
        @tmpdb.stub(:insert)
        TestModel.create("name" => "bob", "foo" => "bar") do |model|
          model["foo"].should eq "bar"
        end        
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
        model2 = mock
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
      
      it "should update by id" do
        p = { "_id" => "123", "name" => "Bob" }
        @tmpdb.should_receive(:update) do |search, model|
          search["_id"].should eq "123"
          model.should eq p
        end
        TestModel.update(p)
      end
    end
      
  end
end