require 'yt/models/base'

module Yt
  module Models
    # The AssetMetadata object specifies the metadata for an asset.
    # @see https://developers.google.com/youtube/partner/docs/v1/assets#metadataMine
    class AssetMetadata < Base
      def initialize(options = {})
        @data = options[:data]
      end

      def custom_id
        @data['customId']
      end

      def title
        @data['title']
      end

      def notes
        @data['notes']
      end

      def description
        @data['description']
      end
    end
  end
end
