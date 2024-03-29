class User < ApplicationRecord
  validates_presence_of :id, :full_name
  validates :id, uniqueness: :true
  has_many :tags
  has_many :accounts, dependent: :destroy
  accepts_nested_attributes_for :tags
end
