require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
  
    describe Connect do
      before do
        @connect = Connect.new
        @client = double(Client)
        @connect.client = @client
        @connect.stub(:args) { HashReader.new( { "name" => "Bob", "password" => "password" } )}
        SpecHelpers.stub_translate_for_testing
      end      
      
      # FAILURE
      describe :handle do        
        it "should fail if there isn't a matching char" do
          Character.should_receive(:find_by_name).with("Bob") { nil }
          Global.should_not_receive(:on_event)
          @client.should_receive(:emit_failure).with("login.char_not_found")
          @connect.handle
        end
                          
        it "should fail if the passwords don't match" do
          found_char = double
          found_char.should_receive(:compare_password).with("password") { false }
          Character.should_receive(:find_by_name).with("Bob") { found_char }
          @client.should_receive(:emit_failure).with("login.invalid_password")
          Global.should_not_receive(:on_event)
          @connect.handle
        end        
      end
      
      # SUCCESS
      describe :handle do
        before do
          @found_char = double
          @dispatcher = double(Dispatcher)
          Global.stub(:dispatcher) { @dispatcher }
          Character.should_receive(:find_by_name) { @found_char }
          @found_char.stub(:compare_password).with("password") { true }  
          
          @dispatcher.stub(:on_event)  
          @client.stub(:char=)      
        end
        
        it "should compare passwords" do
          @found_char.should_receive(:compare_password).with("password")
          @connect.handle
        end        
        
        it "should set the char on the client" do
          @client.should_receive(:char=).with(@found_char)
          @connect.handle
        end

        it "should announce the char connected event" do
           @dispatcher.should_receive(:on_event) do |type, args|
             type.should eq :char_connected
             args[:client].should eq @client
           end
           @connect.handle
        end
      end      
    end
  end
end