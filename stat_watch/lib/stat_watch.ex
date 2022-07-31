defmodule StatWatch do

  def run do
    fetch_stats()
      |> save_csv()
  end

  def column_names() do
    Enum.join(~w(DateTime Subscribers Videos Views), ",")
  end

  def fetch_stats() do
    now = DateTime.to_string(%{DateTime.utc_now() | microsecond: {0, 0}})
    %{body: body} = HTTPoison.get! stat_url()
    %{items: [%{statistics: stats} | _]} = Poison.decode! body, keys: :atoms
    [ now,
      stats.subscriberCount,
      stats.videoCount,
      stats.viewCount
    ] |> Enum.join(", ")
  end

  def save_csv(row_of_stats) do
    filename = "stats.csv"
    unless File.exists?(filename) do
      File.write!(filename, column_names() <> "\n")
    end
    File.write!(filename, row_of_stats <> "\n", [:append])
  end

  def stat_url do
    youtube_api_v3 = "https://www.googleapis.com/youtube/v3/"
    channel = "id=" <> "UCdOTqvJpi9gMQe_00W0EaZA"
    key = "key=" <> "yOuRkEyGoEsHeRe"
    "#{youtube_api_v3}channels?#{channel}&#{key}&part=statistics"
  end
end
