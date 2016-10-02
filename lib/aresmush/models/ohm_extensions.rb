# With credit to: https://github.com/sinefunc/ohm-contrib
module Ohm
  module DataTypes
    module DataType
      Integer   = ->(x) { x.to_i }
      Decimal   = ->(x) { BigDecimal(x.to_s) }
      Float     = ->(x) { x.to_f }
      Symbol    = ->(x) { x && x.to_sym }
      Boolean   = ->(x) { !!x }
      Time      = ->(t) { t && (t.kind_of?(::Time) ? t : ::Time.parse(t)) }
      Date      = ->(d) { d && (d.kind_of?(::Date) ? d : ::Date.parse(d)) }
      Timestamp = ->(t) { t && UnixTime.at(t.to_i) }
      Hash      = ->(h) { h && SerializedHash[h.kind_of?(::Hash) ? h : JSON(h)] }
      Array     = ->(a) { a && SerializedArray.new(a.kind_of?(::Array) ? a : JSON(a)) }
      Set       = ->(s) { s && SerializedSet.new(s.kind_of?(::Set) ? s : JSON(s)) }
    end

    class UnixTime < Time
      def to_s
        to_i.to_s
      end
    end

    class SerializedHash < Hash
      def to_s
        JSON.dump(self)
      end
    end

    class SerializedArray < Array
      def to_s
        JSON.dump(self)
      end
    end

    class SerializedSet < ::Set
      def to_s
        JSON.dump(to_a.sort)
      end
    end
  end
  
  # Provides created_at / updated_at timestamps.
  #
  # @example
  #
  #   class Post < Ohm::Model
  #     include Ohm::Timestamping
  #   end
  #
  #   post = Post.create
  #   post.created_at.to_s == Time.now.utc.to_s
  #   # => true
  #
  #   post = Post[post.id]
  #   post.save
  #   post.updated_at.to_s == Time.now.utc.to_s
  #   # => true
  module Timestamps
    def self.included(base)
      base.attribute :created_at
      base.attribute :updated_at
    end

    def create
      self.created_at ||= Time.now.utc.to_s

      super
    end

    protected
    def write
      self.updated_at = Time.now.utc.to_s

      super
    end
  end
  
end