require "test_helper"

class UserTest < Minitest::Test
   # get tests
   def test_can_get_own_user
      user = Dav::User.get($testuserXtestuser.jwt, $testuser_user["id"])
      assert_equal(user.username, $testuser_user["username"])
      assert_equal(user.email, $testuser_user["email"])
      assert_equal(user.id, $testuser_user["id"])
   end
   
   def test_cant_get_another_user
      begin
         user = Dav::User.get($testuserXdav.jwt, $normalo["id"])
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   
   def test_can_get_apps_of_user
      obj = Dav::Object.create($testuserXdav.jwt, $card["name"], $cards["id"], {test: "test"})

      user = Dav::User.get($testuserXdav.jwt, $testuser_user["id"])
      if assert(user.apps[0])
         obj.delete($testuserXdav.jwt);
      end
   end
   # End get tests
   
   # Update tests
   def test_can_update_the_user
      new_email = "newtest@example.com"
      $normaloXdav.update({"email": new_email})
      assert_equal(new_email, $normaloXdav.new_email)
      
      $normaloXdav.update({"email": $normalo["email"]})
      assert_equal($normaloXdav.new_email, $normalo["email"])
      
      $normaloXdav.update({"avatar_file_extension": ".jpg"})
      assert_equal(".jpg", $normaloXdav.avatar_file_extension)
      
      $normaloXdav.update({"avatar_file_extension": ".png"})
      assert_equal(".png", $normaloXdav.avatar_file_extension)
   end
   
   def test_cant_update_user_with_invalid_email
      begin
         $normaloXdav.update({"email": "1234"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2401"
      end
   end
   
   def test_cant_update_user_with_too_short_username
      begin
         $normaloXdav.update({"username": "2"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2201"
      end
   end
   
   def test_cant_update_user_with_too_long_username
      begin
         $normaloXdav.update({"username": "2"*50})
         assert false
      rescue StandardError => e
         assert e.message.include? "2301"
      end
   end
   
   def test_cant_update_user_with_too_short_password
      begin
         $normaloXdav.update({"password": "1234"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2202"
      end
   end
   
   def test_cant_update_user_with_too_long_password
      begin
         $normaloXdav.update({"password": "1234"*30})
         assert false
      rescue StandardError => e
         assert e.message.include? "2302"
      end
   end
   # End update tests
   
   #create_dev tests
   def test_can_create_dev_from_user
      dev = $normaloXdav.create_dev
      assert !dev.id.nil?
      
      dev.delete($normaloXdav.jwt)
   end
   # End create_dev tests
end
