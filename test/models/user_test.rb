require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = build(:user)
    assert user.valid?
  end

  test "email should be present" do
    user = build(:user, email: nil)
    refute user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_example.com foo@bar..com]

    invalid_addresses.each do |invalid_address|
      user = build(:user, email: invalid_address)
      refute user.valid?
    end
  end

  test "email should be unique" do
    created_user = create(:user)
    user = build(:user, email: created_user.email)

    refute user.valid?
  end

  test "password should be present" do
    user = build(:user, password: nil)
    refute user.valid?
  end

  test "password should not be less than 8 characters" do
    user = build(:user, password: "short")
    refute user.valid?
  end
end
