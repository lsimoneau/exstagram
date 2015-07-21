defmodule Instagram.Subscription do
  defstruct id: nil, aspect: "media", object: nil, object_id: nil, callback_url: nil
  alias Instagram.Request

  def list do
    case Request.get("/subscriptions", [], params: [
      client_id: System.get_env("INSTAGRAM_CLIENT_ID"),
      client_secret: System.get_env("INSTAGRAM_CLIENT_SECRET")
    ]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        json_body = Poison.decode! body
        list = json_body["data"]
        |> Enum.map fn(sub) -> parse(sub) end
        {:ok, list}
      _ -> :error
    end
  end

  defp parse(sub) do
    %Instagram.Subscription{
      id: sub["id"],
      object: sub["object"],
      object_id: sub["object_id"],
      callback_url: sub["callback_url"]
    }
  end
end
