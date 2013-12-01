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
        it "should fail if there isn't a single matching char" do
          find_result = FindResult.new(nil, "Not found")
          SingleTargetFinder.should_receive(:find).with("Bob", Character) { find_result }
          Global.should_not_receive(:on_event)
          @client.should_receive(:emit_failure).with("Not found")
          @connect.handle
        end
                          
        it "should fail if the passwords don't match" do
          found_char = double
          SingleTargetFinder.stub(:find) { FindResult.new(found_char, nil) }
          Character.stub(:compare_password).with(found_char, "password") { false }
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
          
          find_result = FindResult.new(@found_char, nil)
          SingleTargetFinder.stub(:find) { find_result }
          
          Character.stub(:compare_password).with(@found_char, "password") { true }  
          
          @dispatcher.stub(:on_event)  
          @client.stub(:char=)      
        end
        
        it "should compare passwords" do
          Character.should_receive(:compare_password).with(@found_char, "password")
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