require Rails.root.join('config', 'environments', 'production')

Rails.application.configure do
  config.active_support.deprecation = :log
  config.log_level = :debug
end
