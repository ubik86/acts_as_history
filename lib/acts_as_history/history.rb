class History < ActiveRecord::Base
  
  def class_desc
    "Class Name description"
  end
  
  belongs_to :owner,  :polymorphic => true
  
  # these methods are using for serializing objects
  def value= (val) ;   write_attribute(:value, Marshal.dump(val)) ; end
  def value ; Marshal.load read_attribute(:value) ; end 

  named_scope :find_all_by_date, lambda{|time| { :conditions => ["date < ?",time], :order => "date DESC"} }
  named_scope :find_all_by_owner, lambda{|owner| {:conditions => {:owner_id => owner.id,:owner_type => owner.class.name}}}
  named_scope :find_all_from_beginning_date, lambda{|date| {:conditions => ['date < ? AND date > ?', Time.now, date] }}
  
  
  def self.find_first_by_date(date = Time.now)
    self.find_all_by_date(date).first
  end

end