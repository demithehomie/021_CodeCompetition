require 'csv'

class AccountStatementService
  attr_accessor :user_id, :currency, :start_date, :end_date, :tag

  def initialize(params)
    @user_id = params[:user_id]
    @currency = params[:currency]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @tag = params[:tag]
  end

  def create_statement(statement_type)
    case statement_type
    when "deposit"
      create_deposit_statement
    when "min_avg_max"
      create_min_avg_max_statement  
    end
  end

  private

    def create_deposit_statement
      account = Account.find_by(user_id: user_id, currency: currency)
      transactions = Transaction.all
                    .where(account_id: account.id, status: :deposited)
                    .filter_by_date(start_date, end_date)                     

      file_path = "#{Rails.root}/tmp/#{Date.today}-deposit_statement.csv"
      headers = %w(user_id date amount currency)

      CSV.open(file_path, "w", write_headers: true, headers: headers) do |csv|
        transactions.each do |record|
          csv << [account.user_id, record.created_at.to_formatted_s(:long), record.amount, account.currency]
        end
      end
    end

    def create_min_avg_max_statement
      query = Transaction.joins(account: { user: :tags })
              .where(tags: { tag: tag })
              .where(status: "received", created_at: start_date..end_date)

      minimum = query.minimum(:amount)
      average = query.average(:amount)
      maximum = query.maximum(:amount)

      file_path = "#{Rails.root}/tmp/#{Date.today}-min_avg_max_statement.csv"
      headers = %w(tag min_amount max_amount avg_amount date)

      CSV.open(file_path, "w", write_headers: true, headers: headers) do |csv|
        csv << [tag, minimum, maximum, average, "#{start_date} - #{end_date}"]
      end     
    end
end