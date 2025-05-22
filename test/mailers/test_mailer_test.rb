require "test_helper"

class TestMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    mail = TestMailer.welcome_email
    assert_equal "Welcome email", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "demo_email" do
    mail = TestMailer.demo_email
    assert_equal "Demo email", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
