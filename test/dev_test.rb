require "test_helper"

class DevTest < Minitest::Test
   # create tests
   def test_can_create_get_and_delete_dev
      testdev = Dav::Dev.create($normaloXdav.jwt)
      assert_same($normalo["id"], testdev.user_id)
      
      dev = Dav::Dev.get($normaloXdav.jwt)
      assert_same(testdev.id, dev.id)
      
      dev.delete($normaloXdav.jwt)
   end
   # End create tests
   
   # get_by_api_key tests
   def test_can_get_dev_by_api_key
      dev = Dav::Dev.get_by_api_key($dav_dev_auth, $testuser_dev["api_key"])
      assert_equal($testuser_dev["secret_key"], dev.secret_key)
   end
   # End get_by_api_key tests
end