module Dav
	class Archive
		attr_accessor :id, :user_id, :name, :completed, :created_at, :parts

		def initialize(attributes)
			@id = attributes["id"]
			@user_id = attributes["user_id"]
			@name = attributes["name"]
			@completed = attributes["completed"]
			@created_at = attributes["created_at"]
			@parts = Array.new

			if attributes["parts"]
				@parts = convert_json_to_archive_parts_array(attributes["parts"])
				@parts.each { |part| part.archive_id = @id }
			end
		end

		def self.create(jwt)
			url = $api_url + "auth/archive"
			result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)

			if result["code"] == 201
				archive = Archive.new(JSON.parse result["body"])
				return archive
			else
				raise_error(JSON.parse result["body"])
			end
		end

		def self.get(jwt, id)
			url = $api_url + "auth/archive/#{id}"
			result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

			if result["code"] == 200
				archive = Archive.new(JSON.parse result["body"])
				return archive
			else
				raise_error(JSON.parse result["body"])
			end
		end

		def delete(jwt)
			url = $api_url + "auth/archive/#{@id}"
			result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)

			if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
		end
	end
end