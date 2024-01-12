# Automatically set the Accept header to JSON if you're
# describing a controller in the Api or API namespace

RSpec.configure do |config|
  config.before do
    if described_class&.name =~ /Api|API/ && @request.present?
      @request.env['HTTP_ACCEPT'] = 'application/json'
    end
  end
end
