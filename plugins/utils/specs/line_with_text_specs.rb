module AresMUSH
  describe LineWithTextTemplate do
          
    before do
      
    end
            
    describe :render do
      it "should use defaults for an unrecognized line style" do
        config =  { 
          "default" => {
            "color" => "%x!",
            "pattern" => "-=-",
            "text_position" => 5,
            "left_bracket" => '[ ',
            "right_bracket" => ' ]',
          }
         }
      
        allow(Global).to receive(:read_config).with("skin", "line_with_text") {config}
        
        formatter = LineWithTextTemplate.new("TEST TEST", "none")
        expect(formatter.render).to eq "%x!-----[ %xn%xhTEST TEST%xn%x! ]------------------------------------------------------------%xn"
      end
      
      it "should use all regular formatting options" do
        config =  { 
          "default" => {
            "color" => "%xr",
            "pattern" => "=",
            "text_position" => 10,
            "left_bracket" => '<<<',
            "right_bracket" => '>>>',
          }
         }
      
        allow(Global).to receive(:read_config).with("skin", "line_with_text") {config}
        
        formatter = LineWithTextTemplate.new("TEST TEST", "default")
        expect(formatter.render).to eq "%xr==========<<<%xn%xhTEST TEST%xn%xr>>>=====================================================%xn"
      end
      
      it "should truncate text and omit right border if text doesn't fit" do
        config =  { 
          "default" => {
            "color" => "%xr",
            "pattern" => "=",
            "text_position" => 60,
            "left_bracket" => '<<',
            "right_bracket" => '>>',
          }
         }
      
        allow(Global).to receive(:read_config).with("skin", "line_with_text") {config}
        
        formatter = LineWithTextTemplate.new("TEST TEST TEST TEST TEST", "default")
        expect(formatter.render).to eq "%xr============================================================<<%xn%xhTEST TEST TEST%xn%xr>>%xn"
      end
      
      it "should center text" do
        config =  { 
          "default" => {
            "color" => "%xr",
            "pattern" => "=",
            "text_position" => 'center',
            "left_bracket" => '<<',
            "right_bracket" => '>>',
          }
         }
      
        allow(Global).to receive(:read_config).with("skin", "line_with_text") {config}
        
        formatter = LineWithTextTemplate.new("TEST TEST TEST TEST TEST", "default")
        expect(formatter.render).to eq "%xr=========================<<%xn%xhTEST TEST TEST TEST TEST%xn%xr>>=========================%xn"
      end
      
      it "should handle missing fields" do
        config =  { 
          "default" => {
          }
         }
      
        allow(Global).to receive(:read_config).with("skin", "line_with_text") {config}
        
        formatter = LineWithTextTemplate.new("TEST TEST", "default")
        expect(formatter.render).to eq "%x!-----[ %xn%xhTEST TEST%xn%x! ]------------------------------------------------------------%xn"
      end
      
    end
  end
end
