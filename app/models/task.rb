class Task < ActiveRecord::Base
  has_many :submissions
  has_many :test_cases
end
