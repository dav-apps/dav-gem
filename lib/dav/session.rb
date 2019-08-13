module Dav
	class Session
		attr_accessor :id, :user_id, :app_id, :exp, :device_name, :device_type, :device_os, :jwt

		def initialize(attributes)
			@id = attributes["id"]
			@user_id = attributes["user_id"]
			@app_id = attributes["app_id"]
			@exp = attributes["exp"]
			@device_name = attributes["device_name"]
			@device_type = attributes["device_type"]
			@device_os = attributes["device_os"]
         @jwt = attributes["jwt"]
		end

		def self.create(auth_token, email, password, api_key, app_id, device_name, device_type, device_os)
			url = $api_url + "auth/session"
			result = send_http_request(
				url, 
				"POST", 
				{"Authorization" => auth_token, "Content-Type" => "application/json"},
				{"email" => email, "password" => password, "api_key" => api_key, "app_id" => app_id, "device_name" => device_name, "device_type" => device_type, "device_os" => device_os}
			)
			
			if result["code"] == 201
				Session.new(JSON.parse(result["body"]))
			else
				raise_error(result["body"])
			end
		end
	end
end