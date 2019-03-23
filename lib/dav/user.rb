module Dav
   class User
      attr_accessor :email, :username, :confirmed, :new_email, 
                     :old_email, :jwt, :id, :apps, :plan, 
                     :avatar, :total_storage, :used_storage, 
                     :archives, :period_end, :subscription_status
      
      def initialize(attributes)
         @id = attributes["id"]
         @email = attributes["email"]
         @username = attributes["username"]
         @confirmed = attributes["confirmed"]
         @new_email = attributes["new_email"]
         @old_email = attributes["old_email"]
         @apps = convert_json_to_apps_array(attributes["apps"]) if attributes["apps"]
         @plan = attributes["plan"]
         @avatar = attributes["avatar"]
         @total_storage = attributes["total_storage"]
         @used_storage = attributes["used_storage"]
         @archives = convert_json_to_archives_array(attributes["archives"]) if attributes["archives"]
         @period_end = DateTime.parse(attributes["period_end"])
         @subscription_status = attributes["subscription_status"]
      end
      
      def self.get(jwt, user_id)
         url = $api_url + "auth/user/#{user_id.to_s}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            user = User.new(JSON.parse result["body"])
            user.jwt = jwt
            user
         else
            raise_error(JSON.parse result["body"])
         end
      end

      def self.get_by_jwt(jwt)
         url = $api_url + "auth/user"
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
         url = $api_url + "auth/user"
         result = send_http_request(url, "PUT", {"Authorization" => @jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            body = JSON.parse(result["body"])
            @email = body["email"]
            @username = body["username"]
            @confirmed = body["confirmed"]
            @new_email = body["new_email"]
            @old_email = body["old_email"]
            @apps = convert_json_to_apps_array(body["apps"])
            @plan = body["plan"]
            @avatar = body["avatar"]
            @total_storage = body["total_storage"]
            @used_storage = body["used_storage"]
            @archives = convert_json_to_archives_array(body["archives"])
            @period_end = DateTime.parse(body["period_end"])
            @subscription_status = body["subscription_status"]
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def self.send_verification_email(email)
         url = $api_url + "auth/send_verification_email?email=#{email}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.send_reset_password_email(email)
         url = $api_url + "auth/send_reset_password_email?email=#{email}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def self.set_password(password_confirmation_token, password)
         url = $api_url + "auth/set_password/#{password_confirmation_token}?password=#{password}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.save_new_password(id, password_confirmation_token)
         url = $api_url + "auth/user/#{id}/save_new_password/#{password_confirmation_token}"
         result = send_http_request(url , "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.save_new_email(id, email_confirmation_token)
         url = $api_url + "auth/user/#{id}/save_new_email/#{email_confirmation_token}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.reset_new_email(id)
         url = $api_url + "auth/user/#{id}/reset_new_email"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.confirm(id, email_confirmation_token, jwt, password)
         url = $api_url + "auth/user/#{id}/confirm?email_confirmation_token=#{email_confirmation_token}&password=#{password}"
         result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            @confirmed = true
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
      
      def self.delete(user_id, email_confirmation_token, password_confirmation_token)
         url = $api_url + "auth/user/#{user_id}?email_confirmation_token=#{email_confirmation_token}&password_confirmation_token=#{password_confirmation_token}"
         result = send_http_request(url, "DELETE", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end

      def self.send_delete_account_email(email)
         url = $api_url + "auth/send_delete_account_email?email=#{email}"
         result = send_http_request(url, "POST", nil, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end

      def remove_app(app_id)
         url = $api_url + "auth/app/#{app_id}"
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

      def create_archive
         archive = Dav::Archive.create(@jwt)
         @archives.push(archive)
         return archive
      end
   end
end