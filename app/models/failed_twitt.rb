class FailedTwitt < ActiveRecord::Base
  belongs_to :line
  
  def self.last_twitterid
    maximum(:twitter_id)
  end
end

