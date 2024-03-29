class Transaction < ApplicationRecord
  belongs_to :account

  enum status: {
    deposited: 0,
    received: 1
  }

  scope :filter_by_date, ->(start_date, end_date) { where created_at: start_date..end_date }
  scope :filter_by_tag, ->(tag) { where tags: { tag: tag } }

  def self.add_record(account_id, status, amount)
    new_record = new(account_id: account_id, status: status, amount: amount)
    new_record.save!
  end
end
