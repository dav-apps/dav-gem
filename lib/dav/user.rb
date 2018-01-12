module Dav
   class User
      attr_accessor :email, :username, :confirmed, :new_email, :old_email, :avatar_file_extension, :jwt, :id, :apps, :plan
      
      def initialize(attributes)
         @id = attributes["id"]
         @email = attributes["email"]
         @username = attributes["username"]
         @confirmed = attributes["confirmed"]
         @new_email = attributes["new_email"]
         @old_email = attributes["old_email"]
         @avatar_file_extension = attributes["avatar_file_extension"]
         @apps = convert_json_to_apps_array(attributes["apps"])
         @plan = attributes["plan"]
      end
      
      def self.get(jwt, user_id)
         url = $api_url + "users/#{user_id.to_s}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            user = User.new(JSON.parse result["body"])
            user.jwt = jwt
            user
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def update(properties)
         url = $api_url + "users"
         result = send_http_request(url, "PUT", {"Authorization" => @jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            @email = JSON.parse(result["body"])["email"]
            @username = JSON.parse(result["body"])["username"]
            @confirmed = JSON.parse(result["body"])["confirmed"]
            @new_email = JSON.parse(result["body"])["new_email"]
            @old_email = JSON.parse(result["body"])["old_email"]
            @avatar_file_extension = JSON.parse(result["body"])["avatar_file_extension"]
            @apps = JSON.parse(result["body"])["apps"]
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def self.send_verification_email(email)
         url = $api_url + "users/send_verification_email?email=#{email}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.send_reset_password_email(email)
         url = $api_url + "users/send_reset_password_email?email=#{email}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def self.set_password(password_confirmation_token, password)
         url = $api_url + "users/set_password/#{password_confirmation_token}?password=#{password}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.save_new_password(id, password_confirmation_token)
         url = $api_url + "users/#{id}/save_new_password/#{password_confirmation_token}"
         result = send_http_request(url , "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.save_new_email(id, email_confirmation_token)
         url = $api_url + "users/#{id}/save_new_email/#{email_confirmation_token}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.reset_new_email(id)
         url = $api_url + "users/#{id}/reset_new_email"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.confirm(id, email_confirmation_token)
         url = $api_url + "users/#{id}/confirm?email_confirmation_token=#{email_confirmation_token}"
         result = send_http_request(url, "POST", {"Authorization" => @jwt}, nil)
         if result["code"] == 200
            @confirmed = true
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def delete
         url = $api_url + "users"
         result = send_http_request(url, "DELETE", {"Authorization" => @jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end

      def remove_app(app_id)
         url = $api_url + "users/app/#{app_id}"
         result = send_http_request(url, "DELETE", {"Authorization" => @jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def create_dev
         url = $api_url + "devs/dev"
         result = send_http_request(url, "POST", {"Authorization" => @jwt}, nil)
         if result["code"] == 201
            Dav::Dev.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
   end
end