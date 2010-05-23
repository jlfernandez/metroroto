class Station < ActiveRecord::Base
  belongs_to :line

   before_save :set_nicename
  has_many :incidents
  
  has_many :last_incidents, :class_name => "Incident", :conditions => "date > '#{(Time.now - 7.days).to_s(:db)}'", :order => "date DESC"
  named_scope :find_exact_from_twitt, lambda { |string|
    {:conditions => " name = '#{string}' or nicename='#{string.parameterize}'"}
   }

  named_scope :find_from_twitt, lambda { |string|
    {:conditions => " name like '%#{string}%' or nicename like '%#{string.parameterize}%'"}
   }
  named_scope :by_line, lambda { |line|
    {:conditions => "line_id = '#{line}'"}
  }
  
  named_scope :find_outspaces, lambda {|string|
    {:conditions => "REPLACE(nicename,'-','') like '%#{string}%' or REPLACE(nicename,'-','') like '%#{string.parameterize}%' "}
    }

  def status
    result = case 
    when last_incidents.map(&:status).include?(0) then 0
    when last_incidents.map(&:status).include?(1) then 1
    else 2
    end
    result
  end
  
  
  private


  def set_nicename
    self.nicename = self.name.parameterize
  end
  
  def self.update_wrong_stations
    if s = find_by_nicename("colon")
      s.update_attributes(:lat => 40.4254188, :long => -3.6910038)
    end
    if s = find_all_by_nicename("avenida-de-america")
      s.each do |station|
       station.update_attributes(:lat => 40.438035, :long => -3.6766893)
      end
     end
     if s = find_all_by_nicename("pinar-de-chamartin")
       s.each do |station|
       station.update_attributes(:lat =>40.4801375, :long => -3.6667999)
       end
     end 
     if s = find_all_by_nicename("plaza-eliptica")
       s.each do |station|
       station.update_attributes(:lat =>40.3845936, :long => -3.7184733)
       end
     end 
     if s = find_all_by_nicename("moncloa")
       s.each do |station|
       station.update_attributes(:lat =>40.4352293, :long => -3.7191882)
       end
     end    
     if s = find_all_by_nicename("principe-pio")
       s.each do |station|
       station.update_attributes(:lat =>40.4210686, :long => -3.7203813)
       end
     end

     if s = find_all_by_nicename("plaza-de-castilla")
       s.each do |station|
       station.update_attributes(:lat =>40.4668982, :long => -3.6892107)
       end
     end
     
  end
end

