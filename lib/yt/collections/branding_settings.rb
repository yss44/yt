require 'yt/collections/base'
require 'yt/models/branding_setting'

module Yt
  module Collections
    class BrandingSettings < Base

    private

      def attributes_for_new_item(data)
        {data: data['brandingSettings'], auth: @auth}
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   snippet of a resource, for instance a channel.
      # @see https://developers.google.com/youtube/v3/docs/channels#resource
      def list_params
        endpoint = @parent.kind.pluralize.camelize :lower
        super.tap do |params|
          params[:path] = "/youtube/v3/#{endpoint}"
          params[:params] = {id: @parent.id, part: 'brandingSettings'}
        end
      end
    end
  end
end