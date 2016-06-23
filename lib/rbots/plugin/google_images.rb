require "json"

module Rbots::Plugin
  class GoogleImages
    include Hipbot::Plugin

    ANIMATE_ME_DESC = [
      "animate me <query> - The same thing as `image me`, except adds a few",
      "parameters to try to return an animated GIF instead.",
    ].join(" ").freeze
    IMAGE_ME_DESC = [
      "image me <query> - Queries Google Images for <query> and returns a",
      "random top result.",
    ].join(" ").freeze
    PNG_SUFFIX = "#.png".freeze
    SEARCH_URL = "http://ajax.googleapis.com/ajax/services/search/images".freeze

    desc(ANIMATE_ME_DESC)
    on(/(?:animate)(?: me)? (.*)/i) do |match|
      reply_if image_url(match, true)
    end

    desc(IMAGE_ME_DESC)
    on(/(?:image|img)(?: me)? (.*)/i) do |match|
      reply_if image_url(match)
    end

    desc 'stanley me - returns a selfie of stanley'
    on /stanley me\s+$/ { reply_if image_url('axolotl') }

    private

    def reply_if(m)
      reply m if m
    end

    def image_url(query, animated = false)
      params = {
        "q" => query,
        "safe" => "active",
        "v" => "1.0",
        "zsz" => 8,
      }
      params["imgtype"] = "animated" if animated
      uri = URI(SEARCH_URL)
      uri.query = params.map { |pair| pair.join("=") }.join("&")
      response_data = JSON.parse(Net::HTTP.get(uri))
      images = response_data["responseData"]["results"]
      images.length.zero? ? "" : images.sample["unescapedUrl"].concat(PNG_SUFFIX)
    end
  end
end
