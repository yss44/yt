require 'yt/collections/resources'

module Yt
  module Collections
    class Playlists < Resources

    private

      def attributes_for_new_item(data)
        id = use_list_endpoint? ? data['id'] : data['id']['playlistId']
        snippet = data['snippet'].merge includes_tags: false if data['snippet']
        {}.tap do |attributes|
          attributes[:id] = id
          attributes[:snippet] = snippet
          attributes[:auth] = @auth
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list channels.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap do |params|
          params[:params] = playlists_params
          params[:path]   = playlists_path
        end
      end

      def next_page
        super.tap do |items|
          add_offset_to(items) if !use_list_endpoint? && @page_token.nil? && playlists_params[:order] == 'date'
        end
      end

      # According to http://stackoverflow.com/a/23256768 YouTube does not
      # provide more than 500 results for any query. In order to overcome
      # that limit, the query is restarted with a publishedBefore filter in
      # case there are more videos to be listed for a channel
      def add_offset_to(items)
        if items.count == playlists_params[:max_results]
          last_published = items.last['snippet']['publishedAt']
          @page_token, @published_before = '', last_published
        end
      end

      def playlists_params
        {}.tap do |params|
          params[:channel_id] = @parent.id
          params[:type] = :playlist
          params[:max_results] = 50
          params[:part] = 'snippet'
          params[:order] = 'date'
          params[:published_before] = @published_before if @published_before
          apply_where_params! params
        end
      end

      def insert_parts
        snippet = {keys: [:title, :description, :tags], sanitize_brackets: true}
        status = {keys: [:privacy_status]}
        {snippet: snippet, status: status}
      end

      def playlists_path
        use_list_endpoint? ? '/youtube/v3/playlists' : "/youtube/v3/search"
      end

      def use_list_endpoint?
        @where_params ||= {}
        @parent.nil? && (@where_params.keys & [:id, :chart]).any?
      end
    end
  end
end
