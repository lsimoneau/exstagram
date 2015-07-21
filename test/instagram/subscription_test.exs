defmodule Instagram.SubscriptionTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.filter_url_params(true)
    :ok
  end

  test "listing subscriptions when none present" do
    use_cassette "subscriptions_empty" do
      assert Instagram.Subscription.list == {:ok, []}
    end
  end

  test "listing subscriptions when there are some" do
    use_cassette "subscriptions_list" do
      assert Instagram.Subscription.list == {:ok, [
        %Instagram.Subscription{
          id: "19153100",
          object: "tag",
          object_id: "exstagram",
          callback_url: "http://825b08dd.ngrok.io/callback/exstagram"
        }
      ]}
    end
  end

  test "invalid request returns :error" do
    use_cassette "subscriptions_error" do
      client_id = System.get_env("INSTAGRAM_CLIENT_ID")
      System.put_env("INSTAGRAM_CLIENT_ID", "bob")

      assert Instagram.Subscription.list == :error

      # restore original client id
      System.put_env("INSTAGRAM_CLIENT_ID", client_id)
    end
  end
end
