require "test_helper"

class AppTest < Minitest::Test

   # create_archive tests
   def test_can_create_get_and_delete_archive
      # Create an archive
      archive = Dav::Archive.create($davXdav.jwt)

      # Get the archive
      archive2 = Dav::Archive.get($davXdav.jwt, archive.id)
      assert_equal(archive.id, archive2.id)

      # Delete the archive
      archive2.delete($davXdav.jwt)
   end

   def test_cant_create_archive_from_outside_the_website
      begin
         Dav::Archive.create($davXtestuser.jwt)
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   # End create_archive tests
end