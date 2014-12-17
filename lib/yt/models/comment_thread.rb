require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlists.
    # @see https://developers.google.com/youtube/v3/docs/playlists
    class CommentThread < Resource
      delegate :channel_id, :video_id, :top_level_comment,
        :can_reply, :total_reply_count, :is_public, to: :snippet
    end
  end
end
