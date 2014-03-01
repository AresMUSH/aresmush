require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe CreateCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(CreateCmd, "create charname password")
        handler.crack!

        @dispatcher = double.as_null_object
        Global.stub(:dispatcher) { @dispatcher }
        @dispatcher.stub(:on_event)


        @char = double.as_null_object
        Character.should_receive(:new) { @char }

        client.stub(:emit_success)
        client.stub(:char=)        
        
        SpecHelpers.stub_translate_for_testing        
      end

      describe :handle do
        it "should set the character's name" do          
          @char.should_receive(:name=).with("charname")
          handler.handle
        end

        it "should set the character's password" do          
          @char.should_receive(:change_password).with("password")
          handler.handle
        end

        it "should save the character" do          
          @char.should_receive(:save!)
          handler.handle
        end

        it "should tell the char they're created" do
          client.should_receive(:emit_success).with("login.created_and_logged_in")
          handler.handle
        end

        it "should set the char on the client" do
          client.should_receive(:char=).with(@char)
          handler.handle
        end

        it "should dispatch the created and connected event" do
          @dispatcher.should_receive(:on_event) do |type, args|
            type.should eq :char_created
            args[:client].should eq client
          end
         
          @dispatcher.should_receive(:on_event) do |type, args|
            type.should eq :char_connected
            args[:client].should eq client
          end
          handler.handle
        end
      end
    end
  end
end

