class Line < ActiveRecord::Base
  has_many :incidents, :order => "date DESC"
end
