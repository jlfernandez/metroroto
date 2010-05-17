class Subscription < ActiveRecord::Base
   belongs_to :line
   validates_uniqueness_of :email, :scope => :line_id 
end
