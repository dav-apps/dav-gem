module Dav
	class Analytics
		def self.get_app(jwt, id)
			url = $api_url + "analytics/app/#{id}"
			result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

			if result["code"] == 200
            return JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
		end

		def self.get_users(jwt)
			url = $api_url + "analytics/users"
			result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

			if result["code"] == 200
            return JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
		end
	end
end