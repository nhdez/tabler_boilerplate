require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_verified" do
    mail = UserMailer.account_verified
    assert_equal "Account verified", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
