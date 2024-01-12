describe API::BaseController do
  it 'responds to JSON' do
    respond_to = API::BaseController.mimes_for_respond_to
    expect(respond_to).to include :json
  end

  it 'uses the Metova responder' do
    expect(API::BaseController.responder).to eq Metova::Responder
  end
end
