require 'yt/models/description'

module Yt
  module Models
    # Contains basic information about the resource. The details of the snippet
    # are different for the different types of resources.
    #
    # Resources with a
    # snippet are: channels, playlists, playlist items and videos.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    # @see https://developers.google.com/youtube/v3/docs/playlists#resource
    # @see https://developers.google.com/youtube/v3/docs/playlistItems#resource
    class BrandingSetting < Base
      def initialize(options = {})
        @data = options[:data]
        @auth = options[:auth]
      end

      has_attribute :keywords, from: :channel do |channel|
        channel["keywords"]
      end


      def banner_image_url (size = :default)
        if size == :default
          image.fetch("bannerImageUrl", "")
        elsif size == :mobile
          image.fetch("bannerMobileImageUrl", "")
        end
      end

    private

      has_attribute :channel, default: {}
      has_attribute :watch, default: {}
      has_attribute :hints, default: {}
      has_attribute :image, default: {}
    end
  end
end