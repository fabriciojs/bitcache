require 'aws/s3'

module Bitcache::Adapters

  class AWS_S3 < Bitcache::Adapter

    module RepositoryMethods #:nodoc:
      def open(mode = :read, &block)
        @conn ||= AWS::S3::Base.establish_connection!(
          :access_key_id     => config[:access] || ENV['AMAZON_ACCESS_KEY_ID'],
          :secret_access_key => config[:secret] || ENV['AMAZON_SECRET_ACCESS_KEY'])

        bucket = AWS::S3::Bucket.find(config[:bucket])
        block.call(bucket) if block_given?
      end

      def uri() "http://#{AWS::S3::DEFAULT_HOST}/#{config[:bucket]}/" end

      def each(&block)
        open(:read) do |bucket|
          bucket.each do |object|
            stream = self[object.key.to_s]
            stream.instance_variable_set(:@size, object.size.to_i)
            block.call(stream)
          end
        end
      end

      def each_key(&block)
        open(:read) do |bucket|
          bucket.each do |object|
            block.call(object.key.to_s)
          end
        end
      end

      def include?(id)
        open(:read) do |bucket|
          AWS::S3::S3Object.exists?(id, bucket.name)
        end
      end

      def get(id, &block)
        open(:read) do |bucket|
          if body = AWS::S3::S3Object.value(id, bucket.name) rescue nil
            io = StringIO.new(body)
            block_given? ? block.call(io) : io # TODO: S3Object streaming support?
          end
        end
      end

      def post!(data = nil, &block)
        open(:write) do |bucket|
          # TODO
        end
      end

      def put!(id, data = nil, &block)
        open(:write) do |bucket|
          # TODO
        end
      end

      def delete!(id)
        open(:write) do |bucket|
          # TODO
        end
      end
    end

    module StreamMethods #:nodoc:
      def uri()  URI.join(repo.uri, self.id) end
      #def uri()  AWS::S3::S3Object.url_for(self.id, repo.config[:bucket]) end
      def size() @size || -1 end
    end
  end

end