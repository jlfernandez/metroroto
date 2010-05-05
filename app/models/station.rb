class Station < ActiveRecord::Base
  belongs_to :line

   before_save :set_nicename
  has_many :incidents
  named_scope :find_exact_from_twitt, lambda { |string|
    {:conditions => " name = '#{string}' or nicename='#{string}'"}
   }

  named_scope :find_from_twitt, lambda { |string|
    {:conditions => " name like '%#{string}%' or nicename like '%#{string}%'"}
   }
  named_scope :by_line, lambda { |line|
    {:conditions => "line_id = '#{line}'"}
  }
  private


  def set_nicename
    self.nicename = self.name.parameterize
  end
end

