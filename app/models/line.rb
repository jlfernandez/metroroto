class Line < ActiveRecord::Base
  has_many :incidents, :through => :stations
  has_many :stations,:dependent =>:destroy
end

