require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe Create do
      before do
        @create = Create.new
        @client = double
        @create.client = @client
        @create.stub(:args) { HashReader.new( { "name" => "charname", "password" => "password" })}
        SpecHelpers.stub_translate_for_testing                

        @dispatcher = double
        Global.stub(:dispatcher) { @dispatcher }
        Character.stub(:save!)

        @char = double.as_null_object
        Character.should_receive(:new) { @char }

        @client.stub(:emit_success)
        @client.stub(:char=)
        @dispatcher.stub(:on_event)
      end
      
      describe :handle do

        it "should set the character's name" do          
          @char.should_receive(:name=).with("charname")
          @create.handle
        end

        it "should set the character's password" do          
          @char.should_receive(:change_password).with("password")
          @create.handle
        end

        it "should save the character" do          
          @char.should_receive(:save!)
          @create.handle
        end

        it "should tell the char they're created" do
          @client.should_receive(:emit_success).with("login.created_and_logged_in")
          @create.handle
        end

        it "should set the char on the client" do
          @client.should_receive(:char=).with(@char)
          @create.handle
        end

        it "should dispatch the created event" do
          @dispatcher.should_receive(:on_event) do |type, args|
            type.should eq :char_created
            args[:client].should eq @client
          end
          @create.handle
        end
      end
    end
  end
end

