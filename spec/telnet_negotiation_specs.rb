require "aresmush"

module AresMUSH

  describe TelnetNegotiation do

    before do
      @connection = double
      @negotaitor = TelnetNegotiation.new(@connection)
    end
      
    describe "NAWS" do
      it "should ignore a telnet NAWS control code" do
        data = [ 255, 251, 31, 0x30, 0x31, 0x32 ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "012"
      end
      
      it "should shandle a NAWS response with the window size" do
        data = [ 255, 250, 31, 0, 80, 0, 24, 255, 240, 0x30, 0x31, 0x32 ]
        str = data.map { |d| d.chr }.join
        expect(@connection).to receive(:window_width=).with(80)
        expect(@connection).to receive(:window_height=).with(24)
        expect(@negotaitor.handle_input(str)).to eq "012"
      end
    end
    
    describe "Charset" do
      it "should send a charset instruction if the client will do charset commands" do
        data = [ 255, 251, 42, 0x30, 0x31, 0x32 ]
        str = data.map { |d| d.chr }.join
        expected = [ 255, 250, 42, 1, ' '.ord, 'u'.ord, 't'.ord, 'f'.ord, '-'.ord, '8'.ord, 255, 240 ]
        expect(@connection).to receive(:send_data).with( expected.map { |e| e.chr }.join)
        expect(@negotaitor.handle_input(str)).to eq "012"
      end
    end
    
    describe "MSSP" do
      it "should send MSSP to the client" do
        data = [ 255, 253, 70 ]
        str = data.map { |d| d.chr }.join
        expect(@connection).to receive(:send_data) do |response|
          expect(response[0]).to eq 255.chr
          expect(response[1]).to eq 250.chr
          expect(response[2]).to eq 70.chr
          # Unnecessary to check specific game data.
        end
        expect(@negotaitor.handle_input(str)).to eq ""
      end
    end
    
    describe "Negotiation" do
      it "should strip off a do negotiation from the front of a command" do
        data = [ 255, 253, 1, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      it "should strip off a don't negotiation from the front of a command" do
        data = [ 255, 253, 1, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      it "should strip off a do negotiation from the front of a command" do
        data = [ 255, 254, 1, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      it "should strip off a will negotiation from the front of a command" do
        data = [ 255, 251, 1, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      it "should strip off a won't negotiation from the front of a command" do
        data = [ 255, 252, 1, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      it "should strip off a nop negotiation from the front of a command" do
        data = [ 255, 241, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      it "should strip off multiple negotiations in a row from the front of a command" do
        data = [ 255, 241, 255, 252, 1, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      it "should strip off a subnegotiation from the front of a command" do
        data = [ 255, 250, 1, 255, 240, "w".ord, "h".ord, "o".ord ]
        str = data.map { |d| d.chr }.join
        expect(@negotaitor.handle_input(str)).to eq "who"        
      end
      
    end
  end
end
