class Report < ActiveRecord::Base
  attr_accessor :file
  belongs_to :student
end
