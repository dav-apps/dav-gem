require "test_helper"

class DavTest < Minitest::Test
   $dav_user = Hash.new
   $dav_user["id"] = 1
   $dav_user["email"] = "dav@dav-apps.tech"
   $dav_user["password"] = "davdavdav"
   $dav_user["username"] = "dav"
   $dav_user["confirmed"] = true
   
   $dav_dev = Hash.new
   $dav_dev["id"] = 1
   $dav_dev["api_key"] = "eUzs3PQZYweXvumcWvagRHjdUroGe5Mo7kN1inHm"
   $dav_dev["secret_key"] = "Stac8pRhqH0CSO5o9Rxqjhu7vyVp4PINEMJumqlpvRQai4hScADamQ"
   $dav_dev["uuid"] = "d133e303-9dbb-47db-9531-008b20e5aae8"

   $testuser_user = Hash.new
   $testuser_user["id"] = 1
   $testuser_user["email"] = "test@example.com"
   $testuser_user["password"] = "password"
   $testuser_user["username"] = "testuser"
   $testuser_user["confirmed"] = true
   
   $testuser_dev = Hash.new
   $testuser_dev["id"] = 2
   $testuser_dev["api_key"] = "MhKSDyedSw8WXfLk2hkXzmElsiVStD7C8JU3KNGp"
   $testuser_dev["secret_key"] = "5nyf0tRr0GNmP3eB83pobm8hifALZsUq3NpW5En9nFRpssXxlZv-JA"
   $testuser_dev["uuid"] = "71a5d4f8-083e-413e-a8ff-66847a5f3a97"
   
   $nutzer = Hash.new
   $nutzer["id"] = 3
   $nutzer["email"] = "nutzer@testemail.com"
   $nutzer["password"] = "blablablablabla"
   $nutzer["username"] = "nutzer"
   $nutzer["confirmed"] = false
   
   $cards = Hash.new
   $cards["dev_id"] = 1
   $cards["id"] = 1
   $cards["name"] = "Cards"
   
   $testapp = Hash.new
   $testapp["dev_id"] = 2
   $testapp["id"] = 2
   $testapp["name"] = "TestApp"
   
   $card = Hash.new
   $card["name"] = "Card"
   $card["id"] = 1
   $card["app_id"] = 1
   
   $testtable = Hash.new
   $testtable["name"] = "TestTable"
   $testtable["id"] = 2
   $testtable["app_id"] = 2
   
   $testuser_dev_auth = Dav::Auth.new(:api_key => $testuser_dev["api_key"], 
                                    :secret_key => $testuser_dev["secret_key"], 
                                    :uuid => $testuser_dev["uuid"])
   
   $dav_dev_auth = Dav::Auth.new(:api_key => $dav_dev["api_key"],
                                 :secret_key => $dav_dev["secret_key"],
                                 :uuid => $dav_dev["uuid"])
   
   # dav user, logged in through testuser auth token
   $davXtestuser = $testuser_dev_auth.login($dav_user["email"],
                                             $dav_user["password"])
   
   $davXdav = $dav_dev_auth.login($dav_user["email"],
                                 $dav_user["password"])
   
   $testuserXtestuser = $testuser_dev_auth.login($testuser_user["email"], 
                                       $testuser_user["password"])
   
   $testuserXdav = $dav_dev_auth.login($testuser_user["email"], 
                                       $testuser_user["password"])
end