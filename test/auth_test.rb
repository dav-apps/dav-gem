require "test_helper"

class AuthenticationTest < Minitest::Test
   # Login tests
   def test_can_login_user
      user = $dav_dev_auth.login($testuser_user["email"], $testuser_user["password"])
      assert_equal(user.email, $testuser_user["email"])
      assert_equal(user.username, $testuser_user["username"])
      assert_same(user.id, $testuser_user["id"])
   end
   
   def test_trying_logging_in_user_with_incorrect_password_throws_exception
      begin
         user = $dav_dev_auth.login($testuser_user["email"], "wrongpassword")
         assert false
      rescue StandardError => e
         assert e.message.include? "1201"
      end
   end
   # End login tests
   
   # Signup tests
   def test_cant_signup_user_with_taken_email
      begin
         user = $dav_dev_auth.signup($testuser_user["email"], "password", "testtest")
         assert false
      rescue StandardError => e
         assert e.message.include? "2702"
      end
   end
   
   def test_cant_signup_user_with_taken_username
      begin
         user = $dav_dev_auth.signup("test123@example.com", "password", $testuser_user["username"])
         assert false
      rescue StandardError => e
         assert e.message.include? "2701"
      end
   end
   # End signup tests
end