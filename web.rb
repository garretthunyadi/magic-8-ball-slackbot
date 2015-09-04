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

get "magic" do
  "here"

  # response = MAGIC_8_BALL_RESPONSES.sample

  # q = request["text"]
  # payload={"text" => "You asked: '#{q}'"}
  # uri = URI.parse(SLACK_POSTING_URL)
  # response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})

  # payload={"text" => "Magic 8 Ball says: '#{response}'"}
  # uri = URI.parse(SLACK_POSTING_URL)
  # response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})
end

post "magic8" do
  response = MAGIC_8_BALL_RESPONSES.sample

  q = request["text"]
  payload={"text" => "You asked: '#{q}'"}
  uri = URI.parse(SLACK_POSTING_URL)
  response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})

  payload={"text" => "Magic 8 Ball says: '#{response}'"}
  uri = URI.parse(SLACK_POSTING_URL)
  response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})
end

get '/thing1' do
  "Hey tsssshere!"
end
post '/thing2' do
  "Hey tsssshere!"
end

get '/thing3' do
  request["text"]
end
post '/thing4' do
  request["text"]
end

post '/thing5' do
  text = request["text"] || "---"
  payload={"text" => text}
  uri = URI.parse(SLACK_POSTING_URL)
  response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})

end


#curl --data '{"text": "This is a line of text in a channel.\nAnd this is another line of text."}' https://hooks.slack.com/services/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
get "/simon" do
  puts " ----- getting to simon -------"

  q = request["text"]

  payload={"text" => "Simon says '#{q}'"}

  uri = URI.parse(SLACK_POSTING_URL)
  response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})

  return
end
post "/simon" do

  puts " ----- posting to simon -------"
  q = request["text"]

  payload={"text" => "Simon says '#{q}'"}

  uri = URI.parse(SLACK_POSTING_URL)
  response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})

  return
end


def respond(text)
  payload={"text" => text}
  uri = URI.parse(SLACK_POSTING_URL)
  response = Net::HTTP.post_form(uri, {"payload" => JSON.generate(payload)})
end

post "/god" do
  respond(request["text"])
end
get "/god" do
  respond(request["text"])
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


MAGIC_8_BALL_RESPONSES = [
"Signs point to yes.",
"Yes.",
"Reply hazy, try again.",
"Without a doubt.",
"My sources say no.",
"As I see it, yes.",
"You may rely on it.",
"Concentrate and ask again.",
"Outlook not so good.",
"It is decidedly so.",
"Better not tell you now.",
"Very doubtful.",
"Yes - definitely.",
"It is certain.",
"Cannot predict now.",
"Are you fucking kidding me???",
"Most likely.",
"Ask again later.",
"My reply is no.",
"Outlook good.",
"Don't count on it.",
"Yes, in due time.",
"My sources say no.",
"Definitely not.",
"Yes.",
"You will have to wait.",
"I have my doubts.",
"Outlook so so.",
"Looks good to me!",
"Who knows?",
"Looking good!",
"Probably.",
"Are you kidding?",
"Go for it!",
"Don't bet on it.",
"Forget about it.",
]















