require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { build(:account) }
  let(:user) { create(:user) }

  describe "#currency" do
    it "is unique" do
      user.accounts.create(subject.attributes)
      new_account = user.accounts.build(subject.attributes)
      new_account.valid?
      expect(new_account.errors[:currency].size).to eq(1)
    end

    it "allows to share two users same currency per account" do
      user.accounts.create(subject.attributes)
      another_user = create(:user)
      another_account = another_user.accounts.build(subject.attributes)
      expect(another_account).to be_valid
    end

    it "is 3 chars in length" do
      subject.currency = "a" * 30
      subject.valid?
      expect(subject.errors[:currency]).to include("is the wrong length (should be 3 characters)")
    end
  end

  describe ".deposit" do
    context "when amount is a negative number" do
      it "returns false" do
        expect(described_class.deposit(subject, -999)).to be false
      end
    end

    context "when amount is a positive number" do
      it "makes a successfull deposit" do
        deposit_amount = 100
        expect { described_class.deposit(subject, deposit_amount) }
          .to change(subject, :balance).from(0).to(100)
      end

      it "creates a transaction after deposit" do
        amount = 100
        described_class.deposit(subject, amount)
        expect(subject.transactions.deposited).to exist
      end
    end
  end

  describe ".transfer" do
    context "when balance is nil" do
      it "returns false" do
        subject.balance = nil
        recipient_account = build(:account)
        amount = 50
        expect(described_class.transfer(subject, recipient_account, amount)).to be false
      end
    end

    context "when balance is not nil" do
      it "makes a successfull transer" do
        account = subject
        recipient_account = build(:account)
        amount = 50
        expect { described_class.transfer(account, recipient_account, amount) }
          .to change(account, :balance).by(-amount) 
        expect { described_class.transfer(account, recipient_account, amount) }
          .to change(recipient_account, :balance).by(amount)  
      end

      it "creates a transaction after transfer" do
        amount = 50
        recipient_account = build(:account)
        described_class.transfer(subject, recipient_account, amount)
        expect { Transaction.add_record(recipient_account.id, "received", amount) }
          .to change { Transaction.received.count}.by(1)
      end
    end
  end
end
