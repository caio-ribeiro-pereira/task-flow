require "test_helper"

class JsonWebTokenTest < ActiveSupport::TestCase
  def setup
    @payload = { user_id: 1 }
    @token = JsonWebToken.encode(@payload)
  end

  test "should decode token" do
    decoded_payload = JsonWebToken.decode(@token)
    assert_equal @payload.to_json, decoded_payload.to_json
  end

  test "should encode payload" do
    encoded_token = JsonWebToken.encode(@payload)
    assert_equal @token, encoded_token
  end

  test "should return nil when decoded token is expired" do
    Timecop.freeze(48.hours.from_now) do
      assert_nil JsonWebToken.decode(@token)
    end
  end
end
