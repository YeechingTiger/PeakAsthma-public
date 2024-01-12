class NotificationJob < ApplicationJob
  require 'net/http'

  queue_as :default

  FIREBASE_NOTIFICATION_URL = URI.parse('https://fcm.googleapis.com/fcm/send')
  private
    def firebase_http
      http = Net::HTTP.new(FIREBASE_NOTIFICATION_URL.host, FIREBASE_NOTIFICATION_URL.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http
    end

    def firebase_req(post_body)
      @fb_key = Rails.application.secrets.fb_key
      req = Net::HTTP::Post.new(FIREBASE_NOTIFICATION_URL.to_s)
      req['Authorization'] = "key=" + @fb_key
      req['Content-Type'] = 'application/json'
      req.body = post_body.to_json

      req
    end
end
