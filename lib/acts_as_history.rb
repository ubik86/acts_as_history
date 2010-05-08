# Nice plugin for storing history for objects
#  
#
# Author::    Boguslaw Tarnowski
# Copyright:: 3is.pl

require 'acts_as_history/history'

module Ubik86
  module ActsAsHistory
    module View
      # any view helper methods
    end
    
    
    module Model
      def self.included(base)
        base.extend Methods
      end
      
      module Methods
        def acts_as_history(options = {})
          # config params, :delete_form => { :day, :week, :month, :year}
          configuration = { :delete_from => :day, :class_name => self.class_name.underscore} 
          configuration.update(options) if options.is_a?(Hash)
          include Ubik86::ActsAsHistory::Model::InstanceMethods
          include Ubik86::ActsAsHistory::Model::ClassMethods
          @config = configuration
        end
        
        def config
          @config
        end
      end
      
      module ClassMethods
        
      end
      
      module InstanceMethods
        
        #checking if is history from date
        def has_history_from?(date)
           !self.send(self_class_name+'_histories').find_all_from_beginning_date(date).first.nil?
        end
        
        # write history of object to table histories, value field
        def write_history
          date = Time.now.send("beginning_of_#{self.class.config[:delete_from]}") # ustawia okres w ktorym usuwamy stara historie. domyslnie jeden dzień
          self.send(self_class_name+'_histories').find_all_from_beginning_date(date).each {|ch| ch.destroy } if self.has_history_from?(date)
          "History::#{self_class_name.camelize}History".constantize.new(:date => Time.now, :owner => self, :value => self).save
        end
        
        # return historical object for time contain passed in field
        def read_history_for_object(object, field = :created_at)
          obj = self.send(self_class_name+'_histories').find_first_by_date(object.send(field))
          obj.value unless obj.nil?
        end
        
        # return historical object for time time
        def read_history_by_date(date)
          obj = self.send(self_class_name+'_histories').find_first_by_date(date)
          obj.value unless obj.nil?
        end
        
        private
        # return class name
        def self_class_name 
          self.class.class_name.underscore.to_s
        end
      end
    end
  end
end