secrets = Rails.application.secrets

if secrets['metova_smtp_address'] && secrets['metova_smtp_port'] && secrets['metova_smtp_domain'] && secrets['metova_smtp_username'] && secrets['metova_smtp_password']
  Rails.application.configure do
    config.action_mailer.default_url_options = { host: secrets['metova_smtp_host'] }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default :charset => "utf-8"
    config.action_mailer.perform_caching = false

    config.action_mailer.smtp_settings = {
      address: secrets['metova_smtp_address'],
      port: secrets['metova_smtp_port'],
      domain: secrets['metova_smtp_domain'],
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: secrets['metova_smtp_username'],
      password: secrets['metova_smtp_password']
    }
  end
end