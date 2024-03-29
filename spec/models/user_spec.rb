require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it "is valid with an id, full name and tags" do
    user_with_tags = subject.tags.build(attributes_for(:tag))
    expect(user_with_tags).to be_valid
  end

  describe "#full_name" do
    it "is required" do
      subject.full_name = nil
      subject.valid?
      expect(subject.errors[:full_name]).to include("can't be blank")
    end
  end

  describe "#id" do
    it "is required" do
      subject.id = nil
      subject.valid?
      expect(subject.errors[:id].size).to eq(1)
    end

    it "is unique" do
      create(:user, id: 5)
      user = build(:user, id: 5)
      user.valid?
      expect(user.errors[:id]).to include("has already been taken")
    end
  end

  describe "#tag" do
    it "is required" do
      subject.tags.build(tag: nil)
      subject.valid?
      expect(subject).to_not be_valid
    end

    it "accepts nested attributes" do
      expect(subject).to accept_nested_attributes_for(:tags)
    end
  end
end