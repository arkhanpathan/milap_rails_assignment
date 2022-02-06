class Account < ApplicationRecord
  def self.investment_accounts(investment, exclude_account_ids = [])
    return "You don't have sufficient amount in your accounts" if Account.sum(:balance) < investment

    account = Account.where('balance >= ?', investment).where.not(id: exclude_account_ids).order(balance: :asc).first
    return account.name if account.present?

    accounts = []
    max_account = Account.where.not(id: exclude_account_ids).order(balance: :desc).first
    accounts << max_account.name
    remaining_money = investment - max_account.balance
    exclude_account_ids << max_account.id
    accounts << investment_accounts(remaining_money, exclude_account_ids)
    accounts.flatten
  end
end
