class AccountsController < ApplicationController

  def create
    account = set_account(params[:user_id])

    if account.save
      render json: account, status: :created
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def deposit
    account = set_account(params[:user_id])

    if Account.deposit(account, params[:amount].to_d)
      render json: account, status: :ok
    else
      return head :unprocessable_entity
    end
  end

  def transfer
    account = Account.find_by(currency: params[:currency], user_id: params[:user_id])
    return head :not_found unless account

    recipient_account = set_account(params[:recipient_id])

    if Account.transfer(account, recipient_account, params[:amount].to_d)
      render json: { transfered: true }, status: :ok
    else
      return head :unprocessable_entity
    end
  end

  def deposit_statement
    AccountStatementService.new(
      user_id: params[:user_id],
      currency: params[:currency],
      start_date: params[:start_date],
      end_date: params[:end_date]
      ).create_statement("deposit")

    render json: { statement_generated: true }
  end

  def min_avg_max_statement
    AccountStatementService.new(
      tag: params[:tag],
      start_date: params[:start_date],
      end_date: params[:end_date]
      ).create_statement("min_avg_max")

    render json: { statement_generated: true }
  end

  private

  def account_params
    params.require(:account).permit(:currency, :user_id, :amount, :recipient_id, :start_date, :end_date)
  end

  def set_account(user_id)
    account = Account.find_by(currency: params[:currency], user_id: user_id)
    if account.nil?
      user = User.find(user_id)
      account = user.accounts.build(currency: params[:currency])
    else
      account
    end
  end
end