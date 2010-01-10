module Bitcache
  ##
  class Stream
    include Comparable

    ##
    # @return [String] the bitstream's identifier
    attr_reader :id

    ##
    # @return [String] the bitstream's contents
    attr_reader :data

    ##
    # Initializes this bitstream instance.
    #
    # @param  [String] id
    # @param  [String] data
    def initialize(id, data)
      @id, @data = id, data
    end

    ##
    # Returns `true` to indicate this is a bitstream.
    def stream?
      true
    end

    ##
    # @return [String] the bitstream's identifier
    def to_s
      id
    end

    ##
    # @return [String] the bitstream's contents
    def to_str
      data
    end
  end
end
