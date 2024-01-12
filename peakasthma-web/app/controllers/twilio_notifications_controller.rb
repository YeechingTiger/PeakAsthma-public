class TwilioNotificationsController < ApplicationController 
  skip_before_action :verify_authenticity_token
  
  @@server_url = ENV['SERVER_URL']
  def reply
    message_body = params["Body"]
    from_number = params["From"]
    boot_twilio
    sms = @client.messages.create(
      from: Rails.application.secrets.twilio_number,
      to: from_number,
      body: "You know it! #{message_body}"
    )
  end
   
  def red_voice
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.play(loop: 2, url: 'https://peakasthma.org/voices/redZoneVoice.mp3')
    end
    puts response
    render :xml => response.to_xml
  end

  def yellow_voice
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.play(loop: 2, url: 'https://peakasthma.org/voices/yellowZoneVoice.mp3')
    end
    puts response
    render :xml => response.to_xml
  end

  private
 
  def boot_twilio
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
