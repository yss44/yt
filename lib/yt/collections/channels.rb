require 'yt/collections/resources'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube channels.
    #
    # Resources with channels are: {Yt::Models::Account accounts}.
    class Channels < Resources

    private

      def attributes_for_new_item(data)
        id = use_list_endpoint? ? data["id"] : data["id"]["channelId"]
        super(data).tap do |attributes|
          attributes[:id]         = id
          attributes[:statistics] = data['statistics']
          attributes[:snippet]    = data["snippet"]
          attributes[:status]     = data['status']
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list channels.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap do |params|
          params[:params] = channels_params
          params[:path]   = channels_path
        end
      end

      def next_page
        super.tap do |items|
          add_offset_to(items) if !use_list_endpoint? && @page_token.nil? && channels_params[:order] == 'date'
        end
      end

      def add_offset_to(items)
        if items.count == channels_params[:max_results]
          last_published = items.last['snippet']['publishedAt']
          @page_token, @published_before = '', last_published
        end
      end

      def channels_params
        params = resources_params.tap do |params|
          params[:mine]  = true if @parent
          params[:part]  = "snippet" if !use_list_endpoint?
          params[:type]  = "channel" if !use_list_endpoint?
          params[:order] = "date"    if !use_list_endpoint?
          params[:published_before] = @published_before if @published_before

        end
        apply_where_params! params
      end

      def channels_path
        use_list_endpoint? ? "/youtube/v3/channels" : "/youtube/v3/search"
      end

      def use_list_endpoint?
        @where_params ||= {}
        @parent.nil? && @parent.class == Yt::Models::Account
      end
    end
  end
end