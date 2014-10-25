module AresMUSH
  module ApiCrypt
    def self.encrypt(key, data)
      cipher = OpenSSL::Cipher.new('AES-128-CBC')
      cipher.encrypt
      iv = ApiCrypt.generate_iv
      cipher.key = key
      cipher.iv = iv
      encrypted = cipher.update(data).force_encoding('ascii-8bit') + cipher.final
      encrypted = Base64.strict_encode64(encrypted).encode('ASCII-8BIT')
      { :data => encrypted, :iv => iv }
    end
    
    def self.decrypt(key, iv, data)
      data = Base64.strict_decode64 data.encode('ASCII-8BIT')
      cipher = OpenSSL::Cipher.new('AES-128-CBC')
      cipher.decrypt
      cipher.key = key
      cipher.iv = iv
      cipher.update(data) + cipher.final
    end
    
    def self.generate_iv
      rand(10 ** 20).to_s.rjust(20,'0')
    end
    
    def self.generate_key
      cipher = OpenSSL::Cipher.new('AES-128-CBC')
      cipher.encrypt
      key = cipher.random_key
      Base64.strict_encode64(key).encode('ASCII-8BIT')
    end

    # input string in format <iv> <encrypted response>
    def self.decode_response(key, str)
      iv = str.before(" ")
      encrypted = str.after(" ")
      data = ApiCrypt.decrypt(key, iv, encrypted)
      ApiResponse.create_from(data)
    end
  end
end