require 'acts_as_history'
ActiveRecord::Base.send(:include, Ubik86::ActsAsHistory::Model)