module Dav
	class Analytics
		def self.get_app(jwt, id)
			url = $api_url + "analytics/app/#{id}"
			result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

			if result["code"] == 200
            return JSON.parse(result["body"])
         else
            raise_error(result["body"])
         end
		end

		def self.get_users(jwt)
			url = $api_url + "analytics/users"
			result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

			if result["code"] == 200
            return JSON.parse(result["body"])
         else
            raise_error(result["body"])
         end
		end

		def self.get_active_users(jwt, start_timestamp = Time.now.to_i - 2629746, end_timestamp = Time.now.to_i)
			url = $api_url + "analytics/active_users?start=#{start_timestamp}&end=#{end_timestamp}"
			result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

			if result["code"] == 200
				return convert_json_to_active_users_array(JSON.parse(result["body"])["days"])
			else
				raise_error(result["body"])
			end
		end
	end
end