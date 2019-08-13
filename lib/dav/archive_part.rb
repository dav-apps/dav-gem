module Dav
	class ArchivePart
		attr_accessor :id, :archive_id, :name

		def initialize(attributes)
			@id = attributes["id"]
			@archive_id = attributes["archive_id"]
			@name = attributes["name"]
		end

		def self.get(jwt, id)
			url = $api_url + "auth/archive_part/#{id}"
			result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

			if result["code"] == 200
				ArchivePart.new(JSON.parse result["body"])
			else
				raise_error(result["body"])
			end
		end
	end
end