#ruby
require 'bundler/setup'
require 'json'
require 'net/http'
require 'sinatra'

SLACK_TOKEN="RLZn3p2IpZbUCXDBKZExlxZz"
GIPHY_KEY="dc6zaTOxFJmzC"
TRIGGER_WORD="#"
IMAGE_STYLE="fixed_height" # or "fixed_width" or "original"
SLACK_POSTING_URL="https://hooks.slack.com/services/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"

get '/' do
  "Hey there!"
end

post '/' do
  "Woot!"
end



#curl --data '{"text": "This is a line of text in a channel.\nAnd this is another line of text."}' https://hooks.slack.com/services/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
post "/simon" do
  q = request["text"]

  payload={"text": "Simon says ''"}

  uri = URI.parse(SLACK_POSTING_URL)
  response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})

  return
end

post "/gif" do
  # return 401 unless request["token"] == SLACK_TOKEN
  q = request["text"]
  return 200 unless q.start_with? TRIGGER_WORD
  q = URI::encode q[TRIGGER_WORD.size..-1]
  url = "http://api.giphy.com/v1/gifs/search?q=#{q}&api_key=#{GIPHY_KEY}&limit=50"
  # $stderr.puts "querying giphy: #{url}"
  resp = Net::HTTP.get_response(URI.parse(url))
  buffer = resp.body
  result = JSON.parse(buffer) 
  images = result["data"].map {|item| item["images"]}
  # filter out images > 2MB(?) because Slack
  images.select! {|image| image["original"]["size"].to_i < 1<<21}
  if images.empty?
    text = ":cry:"
  else
    selected = images[rand images.size]
    text = "<" + selected[IMAGE_STYLE]["url"] + ">"
  end
  reply = {username: "giphy", icon_emoji: ":monkey_face:", text: text}
  return JSON.generate(reply)
end
