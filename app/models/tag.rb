class Tag < ApplicationRecord
  belongs_to :user
  validates_presence_of :tag
end
