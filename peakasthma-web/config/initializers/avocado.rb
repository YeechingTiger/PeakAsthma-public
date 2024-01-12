Avocado.configure do |config|
  config.url = nil
  config.headers = ['Authorization']
  config.document_if = proc { ENV['AVOCADO'] }
  config.upload_id = proc { ENV['BUILD_NUMBER'] }
  config.uploader = Avocado::Uploader.instance
  config.storage = Avocado::Storage::File.new Rails.root.join('..', '..', 'shared')
end
