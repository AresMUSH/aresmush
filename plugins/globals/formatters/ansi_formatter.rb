module AresMUSH
  class AnsiFormatter  
    # @engineinternal true  
    def self.ansi_code_map
      {
        "x" => ANSI.black,
        "r" => ANSI.red,
        "g" => ANSI.green,
        "y" => ANSI.yellow,
        "b" => ANSI.blue,
        "m" => ANSI.magenta,
        "c" => ANSI.cyan,
        "w" => ANSI.white,

        "X" => ANSI.on_black,
        "R" => ANSI.on_red,
        "G" => ANSI.on_green,
        "Y" => ANSI.on_yellow,
        "B" => ANSI.on_blue,
        "M" => ANSI.on_magenta,
        "C" => ANSI.on_cyan,
        "W" => ANSI.on_white,

        "u" => ANSI.underline,
        "h" => ANSI.bold,
        "i" => ANSI.inverse,

        "U" => ANSI.underline_off,
        "I" => ANSI.reveal,  # Should be inverse_off but there appears to be a bug in the ANSI lib.
        "H" => ANSI.bold_off,

        "n" => ANSI.reset,
        "N" => ANSI.reset
        
        # No, I did not forget 'blink'.  Blink is evil. :)
      }
    end
    
    # @engineinternal true  
    def self.grayscale_code_map
      {
        "x" => ANSI.black,
        "r" => "",
        "g" => "",
        "y" => "",
        "b" => "",
        "m" => "",
        "c" => "",
        "w" => ANSI.white,

        "X" => ANSI.on_black,
        "R" => "",
        "G" => "",
        "Y" => "",
        "B" => "",
        "M" => "",
        "C" => "",
        "W" => ANSI.on_white,
        
        "u" => ANSI.underline,
        "h" => ANSI.bold,
        "i" => ANSI.inverse,

        "U" => ANSI.underline_off,
        "I" => ANSI.reveal,  # Should be inverse_off but there appears to be a bug in the ANSI lib.
        "H" => ANSI.bold_off,

        "n" => ANSI.reset,
        "N" => ANSI.reset
      }
    end
      
    # @engineinternal true  

    def self.fansi_downgrade_map
      {
         "0" => "#{ANSI.black}",
         "1" => "#{ANSI.red}",
         "2" => "#{ANSI.green}",
         "3" => "#{ANSI.yellow}",
         "4" => "#{ANSI.blue}",
         "5" => "#{ANSI.magenta}",
         "6" => "#{ANSI.cyan}",
         "7" => "#{ANSI.white}",
         "8" => "#{ANSI.black}",
         "9" => "#{ANSI.red}",
         "10" => "#{ANSI.green}",
         "11" => "#{ANSI.yellow}",
         "12" => "#{ANSI.blue}",
         "13" => "#{ANSI.magenta}",
         "14" => "#{ANSI.cyan}",
         "15" => "#{ANSI.white}",
         "16" => "#{ANSI.black}",
         "17" => "#{ANSI.blue}",
         "18" => "#{ANSI.blue}",
         "19" => "#{ANSI.blue}",
         "20" => "#{ANSI.blue}",
         "21" => "#{ANSI.blue}",
         "22" => "#{ANSI.green}",
         "23" => "#{ANSI.cyan}",
         "24" => "#{ANSI.blue}",
         "25" => "#{ANSI.blue}",
         "26" => "#{ANSI.blue}",
         "27" => "#{ANSI.blue}",
         "28" => "#{ANSI.green}",
         "29" => "#{ANSI.green}",
         "30" => "#{ANSI.cyan}",
         "31" => "#{ANSI.blue}",
         "32" => "#{ANSI.blue}",
         "33" => "#{ANSI.blue}",
         "34" => "#{ANSI.green}",
         "35" => "#{ANSI.green}",
         "36" => "#{ANSI.cyan}",
         "37" => "#{ANSI.cyan}",
         "38" => "#{ANSI.blue}",
         "39" => "#{ANSI.blue}",
         "40" => "#{ANSI.green}",
         "41" => "#{ANSI.green}",
         "42" => "#{ANSI.green}",
         "43" => "#{ANSI.cyan}",
         "44" => "#{ANSI.cyan}",
         "45" => "#{ANSI.cyan}",
         "46" => "#{ANSI.green}",
         "47" => "#{ANSI.green}",
         "48" => "#{ANSI.green}",
         "49" => "#{ANSI.cyan}",
         "50" => "#{ANSI.cyan}",
         "51" => "#{ANSI.cyan}",
         "52" => "#{ANSI.red}",
         "53" => "#{ANSI.magenta}",
         "54" => "#{ANSI.magenta}",
         "55" => "#{ANSI.magenta}",
         "56" => "#{ANSI.blue}",
         "57" => "#{ANSI.blue}",
         "58" => "#{ANSI.green}",
         "59" => "#{ANSI.green}",
         "60" => "#{ANSI.cyan}",
         "61" => "#{ANSI.blue}",
         "62" => "#{ANSI.blue}",
         "63" => "#{ANSI.blue}",
         "64" => "#{ANSI.green}",
         "65" => "#{ANSI.green}",
         "66" => "#{ANSI.green}",
         "67" => "#{ANSI.cyan}",
         "68" => "#{ANSI.cyan}",
         "69" => "#{ANSI.blue}",
         "70" => "#{ANSI.green}",
         "71" => "#{ANSI.green}",
         "72" => "#{ANSI.green}",
         "73" => "#{ANSI.cyan}",
         "74" => "#{ANSI.cyan}",
         "75" => "#{ANSI.cyan}",
         "76" => "#{ANSI.green}",
         "77" => "#{ANSI.green}",
         "78" => "#{ANSI.green}",
         "79" => "#{ANSI.cyan}",
         "80" => "#{ANSI.cyan}",
         "81" => "#{ANSI.cyan}",
         "82" => "#{ANSI.green}",
         "83" => "#{ANSI.green}",
         "84" => "#{ANSI.green}",
         "85" => "#{ANSI.green}",
         "86" => "#{ANSI.cyan}",
         "87" => "#{ANSI.cyan}",
         "88" => "#{ANSI.red}",
         "89" => "#{ANSI.red}",
         "90" => "#{ANSI.magenta}",
         "91" => "#{ANSI.magenta}",
         "92" => "#{ANSI.magenta}",
         "93" => "#{ANSI.magenta}",
         "94" => "#{ANSI.red}",
         "95" => "#{ANSI.red}",
         "96" => "#{ANSI.magenta}",
         "97" => "#{ANSI.magenta}",
         "98" => "#{ANSI.magenta}",
         "99" => "#{ANSI.magenta}",
         "100" => "#{ANSI.yellow}",
         "101" => "#{ANSI.yellow}",
         "102" => "#{ANSI.green}",
         "103" => "#{ANSI.cyan}",
         "104" => "#{ANSI.blue}",
         "105" => "#{ANSI.blue}",
         "106" => "#{ANSI.green}",
         "107" => "#{ANSI.green}",
         "108" => "#{ANSI.green}",
         "109" => "#{ANSI.cyan}",
         "110" => "#{ANSI.cyan}",
         "111" => "#{ANSI.cyan}",
         "112" => "#{ANSI.green}",
         "113" => "#{ANSI.green}",
         "114" => "#{ANSI.green}",
         "115" => "#{ANSI.green}",
         "116" => "#{ANSI.cyan}",
         "117" => "#{ANSI.cyan}",
         "118" => "#{ANSI.green}",
         "119" => "#{ANSI.green}",
         "120" => "#{ANSI.green}",
         "121" => "#{ANSI.green}",
         "122" => "#{ANSI.white}",
         "123" => "#{ANSI.white}",
         "124" => "#{ANSI.red}",
         "125" => "#{ANSI.magenta}",
         "126" => "#{ANSI.magenta}",
         "127" => "#{ANSI.magenta}",
         "128" => "#{ANSI.magenta}",
         "129" => "#{ANSI.magenta}",
         "130" => "#{ANSI.red}",
         "131" => "#{ANSI.red}",
         "132" => "#{ANSI.red}",
         "133" => "#{ANSI.magenta}",
         "134" => "#{ANSI.magenta}",
         "135" => "#{ANSI.magenta}",
         "136" => "#{ANSI.yellow}",
         "137" => "#{ANSI.yellow}",
         "138" => "#{ANSI.magenta}",
         "139" => "#{ANSI.magenta}",
         "140" => "#{ANSI.magenta}",
         "141" => "#{ANSI.magenta}",
         "142" => "#{ANSI.yellow}",
         "143" => "#{ANSI.yellow}",
         "144" => "#{ANSI.yellow}",
         "145" => "#{ANSI.magenta}",
         "146" => "#{ANSI.magenta}",
         "147" => "#{ANSI.magenta}",
         "148" => "#{ANSI.yellow}",
         "149" => "#{ANSI.yellow}",
         "150" => "#{ANSI.green}",
         "151" => "#{ANSI.white}",
         "152" => "#{ANSI.white}",
         "153" => "#{ANSI.white}",
         "154" => "#{ANSI.yellow}",
         "155" => "#{ANSI.yellow}",
         "156" => "#{ANSI.yellow}",
         "157" => "#{ANSI.yellow}",
         "158" => "#{ANSI.white}",
         "159" => "#{ANSI.white}",
         "160" => "#{ANSI.red}",
         "161" => "#{ANSI.red}",
         "162" => "#{ANSI.magenta}",
         "163" => "#{ANSI.magenta}",
         "164" => "#{ANSI.magenta}",
         "165" => "#{ANSI.magenta}",
         "166" => "#{ANSI.red}",
         "167" => "#{ANSI.red}",
         "168" => "#{ANSI.red}",
         "169" => "#{ANSI.magenta}",
         "170" => "#{ANSI.magenta}",
         "171" => "#{ANSI.magenta}",
         "172" => "#{ANSI.yellow}",
         "173" => "#{ANSI.yellow}",
         "174" => "#{ANSI.yellow}",
         "175" => "#{ANSI.magenta}",
         "176" => "#{ANSI.magenta}",
         "177" => "#{ANSI.magenta}",
         "178" => "#{ANSI.yellow}",
         "179" => "#{ANSI.yellow}",
         "180" => "#{ANSI.yellow}",
         "181" => "#{ANSI.magenta}",
         "182" => "#{ANSI.magenta}",
         "183" => "#{ANSI.magenta}",
         "184" => "#{ANSI.yellow}",
         "185" => "#{ANSI.yellow}",
         "186" => "#{ANSI.yellow}",
         "187" => "#{ANSI.white}",
         "188" => "#{ANSI.white}",
         "189" => "#{ANSI.white}",
         "190" => "#{ANSI.yellow}",
         "191" => "#{ANSI.yellow}",
         "192" => "#{ANSI.yellow}",
         "193" => "#{ANSI.white}",
         "194" => "#{ANSI.white}",
         "195" => "#{ANSI.white}",
         "196" => "#{ANSI.red}",
         "197" => "#{ANSI.red}",
         "198" => "#{ANSI.red}",
         "199" => "#{ANSI.magenta}",
         "200" => "#{ANSI.magenta}",
         "201" => "#{ANSI.magenta}",
         "202" => "#{ANSI.red}",
         "203" => "#{ANSI.red}",
         "204" => "#{ANSI.red}",
         "205" => "#{ANSI.magenta}",
         "206" => "#{ANSI.magenta}",
         "207" => "#{ANSI.magenta}",
         "208" => "#{ANSI.red}",
         "209" => "#{ANSI.red}",
         "210" => "#{ANSI.magenta}",
         "211" => "#{ANSI.magenta}",
         "212" => "#{ANSI.magenta}",
         "213" => "#{ANSI.magenta}",
         "214" => "#{ANSI.yellow}",
         "215" => "#{ANSI.yellow}",
         "216" => "#{ANSI.white}",
         "217" => "#{ANSI.white}",
         "218" => "#{ANSI.white}",
         "219" => "#{ANSI.white}",
         "220" => "#{ANSI.yellow}",
         "221" => "#{ANSI.yellow}",
         "222" => "#{ANSI.yellow}",
         "223" => "#{ANSI.white}",
         "224" => "#{ANSI.white}",
         "225" => "#{ANSI.white}",
         "226" => "#{ANSI.yellow}",
         "227" => "#{ANSI.yellow}",
         "228" => "#{ANSI.yellow}",
         "229" => "#{ANSI.yellow}",
         "230" => "#{ANSI.white}",
         "231" => "#{ANSI.white}",
         "232" => "#{ANSI.black}",
         "233" => "#{ANSI.black}",
         "234" => "#{ANSI.black}",
         "235" => "#{ANSI.black}",
         "236" => "#{ANSI.black}",
         "237" => "#{ANSI.black}",
         "238" => "#{ANSI.black}",
         "239" => "#{ANSI.black}",
         "240" => "#{ANSI.black}",
         "241" => "#{ANSI.white}",
         "242" => "#{ANSI.white}",
         "243" => "#{ANSI.white}",
         "244" => "#{ANSI.white}",
         "245" => "#{ANSI.white}",
         "246" => "#{ANSI.white}",
         "247" => "#{ANSI.white}",
         "248" => "#{ANSI.white}",
         "249" => "#{ANSI.white}",
         "250" => "#{ANSI.white}",
         "251" => "#{ANSI.white}",
         "252" => "#{ANSI.white}",
         "253" => "#{ANSI.white}",
         "254" => "#{ANSI.white}",
         "255" => "#{ANSI.white}",
         "256" => "#{ANSI.white}"
      }
    end
    
    def self.strip_ansi(str)
      return "" if !str
      str.gsub(/\e\[(\d+)(;\d+)*m/, '')
    end
    
    # Given a string like %xb or %c102, returns the appropriate ansified string, 
    # or nil if ansi code is not valid.
    def self.get_code(str, color_mode = "FANSI")
      matches = /^%(?<control>[XxCc])(?<code>.+)/.match(str)
      return nil if !matches
        
      control = matches[:control]
      code = matches[:code]

      code_map = color_mode == "NONE" ? grayscale_code_map : ansi_code_map
      
      if (code_map.has_key?(code))
        return code_map[code]
      elsif (code.to_i > 0 && code.to_i < 257)
        if (color_mode == "FANSI")
          if (control == "X" || control == "C")
            return "\e[48;5;#{code}m"
          else
            return "\e[38;5;#{code}m"
          end
        elsif (color_mode == "ANSI")
          downgrade = fansi_downgrade_map[code.to_s] || 0
          if (control == "X" || control == "C")
            return "#{ANSI.inverse}#{downgrade}"
          else
            return "#{downgrade}"
          end
        else
          return ""
        end
      else
        return nil
      end
    end
  end
end