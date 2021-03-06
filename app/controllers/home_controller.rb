class HomeController < ApplicationController

  def index
    @six_months_ago = Time.now - 6.months

    @tweets = $twitter.get_all_tweets("JKCorden").select { |tweet| tweet.created_at >= @six_months_ago }

  end

  private

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  def $twitter.get_all_tweets(user)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: true}
      options[:max_id] = max_id unless max_id.nil?
      user_timeline(user, options)
    end
  end
end
