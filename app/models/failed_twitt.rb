class FailedTwitt < ActiveRecord::Base
  belongs_to :line
  validates_presence_of :station_string
end

