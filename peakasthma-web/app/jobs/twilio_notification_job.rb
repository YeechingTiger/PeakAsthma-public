class TwilioNotificationJob < ApplicationJob
  queue_as :default
  @@server_url = ENV['SERVER_URL']

  def perform(peak_flow, patient, exacerbation)
    for guardian in patient.guardians
      to_number = guardian.phone
      zone_level = peak_flow.level
      zone_level = :red if zone_level == :red_now
      boot_twilio
      if guardian.notification_type == 'Text + Email'
        if zone_level == :yellow
          sms = @client.messages.create(
            from: Rails.application.secrets.twilio_number,
            to: to_number,
            body: 
              "This is a message from Dr. Perry’s PEAKmAAP research team at Arkansas Children’s. Your child is enrolled in the PEAKmAAP asthma study.\n" + 
              "You are receiving this message because your child has logged yellow zone symptoms for the last 48 hours, without indicating improvement. " + 
              "Please check on your child’s symptoms. If your child is still experiencing asthma symptoms or has failed to improve, please contact " + 
              "your primary care doctor for further instructions.\nIf you receive this message after regular business hours and your child needs medical " + 
              "attention, call your PCP on-call doctor or Kid Care Line at 501-364-1202 for advice. If your child is experiencing a medical emergency, " + 
              "please call 911."
          )
        else
          sms = @client.messages.create(
            from: Rails.application.secrets.twilio_number,
            to: to_number,
            body: 
              "This is a message from Dr. Perry’s PEAKmAAP research team at Arkansas Children’s. Your child is enrolled in the PEAKmAAP asthma study.\n" + 
              "You are receiving this message because your child has logged red zone symptoms for over an hour, without indicating improvement. Please " + 
              "check on your child’s symptoms. If your child is still experiencing asthma symptoms or has failed to improve, please contact your " + 
              "primary care doctor for further instructions.\nIf you receive this message after regular business hours and your child needs medical " + 
              "attention, call your PCP on-call doctor or Kids Care line at 501-364-1202 for advice. If your child is experiencing a medical emergency, " + 
              "please call 911."
          )
        end
      end

      if guardian.notification_type == 'Phone Call + Email'
        if zone_level == :yellow
            call = @client.calls.create(
            url: "#{@@server_url}/yellow_voice",
            to: to_number,
            from: Rails.application.secrets.twilio_number,
          )
        else
            call = @client.calls.create(
            url: "#{@@server_url}/red_voice",
            to: to_number,
            from: Rails.application.secrets.twilio_number,
          )
        end
        TwilioPhoneCall.create(
          twilio_sid: call.sid,
          exacerbation: exacerbation,
        )

      end
    end

  end

  private
  def boot_twilio
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
