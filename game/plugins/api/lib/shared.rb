module AresMUSH
  module Api
    
    mattr_accessor :router
    
    def self.create_router
      if (Api.is_master?)
        self.router = ApiMasterRouter.new
      else
        self.router = ApiSlaveRouter.new
      end
    end
    
    def self.is_master?
      Global.config['api']['is_master']
    end
    
    def self.get_destination(dest_id)
      ServerInfo.where(game_id: dest_id).first
    end
    
    def self.encrypt(key, data)
      cipher = OpenSSL::Cipher.new('AES-128-CBC')
      cipher.encrypt
      iv = Api.generate_iv
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

    # string in format <iv> <encrypted response>
    def self.decode_response(client, key, str)
      iv = str.before(" ")
      encrypted = str.after(" ")
      begin
        data = Api.decrypt(key, iv, encrypted)
        ApiResponseEvent.new(client, data, nil)
      rescue OpenSSL::Cipher::CipherError
        Global.logger.error "Cipher error decoding response #{str} with key #{key}."
        ApiResponseEvent.new(client, nil, t('api.api_cipher_error'))
      end
    end
  end
end