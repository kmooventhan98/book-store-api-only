require 'rails_helper'
describe AuthenticationTokenService do
  let(:token) {described_class.call}
  it 'returns an authentication token' do
    hmac_secret = 'my$ecretK3y'
    decoded_token = JWT.decode(
      token,
      described_class::HMAC_SECRET,
      true,
      { algorithm: described_class::ALGORITHM_TYPE }
    ) 
    expect(decoded_token).to eq(
      [
        {"username" => "user"},
        {"alg" => "HS256"}
      ]
    )
  end
end
