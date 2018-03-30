require "instagram"
require 'open-uri'

class PhotoController < ApplicationController
  CALLBACK_URL = "http://localhost:3000/callback"
  CLIENT_ID = "5a8bbf3e261547938e5f015379f9e881"
  CLIENT_SECRET = "1c888297ef02421b8123c29de8b95f0f"

  Instagram.configure do |config|
    config.client_id = CLIENT_ID
    config.client_secret = CLIENT_SECRET
    # For secured endpoints only
    #config.client_ips = '<Comma separated list of IPs>'
  end

  def photo
      redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    @access_token = response.access_token
    client = Instagram.client(:access_token => @access_token)
    user = client.user
    @html = "<h1>#{user.username}'s recent media</h1>"
    for media_item in client.user_recent_media
      @html << "<div style='float:left;'><img src='#{media_item.images.standard_resolution.url}'><br/> <a href='/media_like/#{media_item.id}'>Like</a>  <a href='/media_unlike/#{media_item.id}'>Un-Like</a>  <br/>LikesCount=#{media_item.likes[:count]} #{media_item}</div>"
      if media_item.type == 'image'
        open("./downloads/#{media_item.id}.png", 'wb') do |file|
          file << open("#{media_item.images.standard_resolution.url}").read
        end
      elsif media_item.type == 'video'
        open("./downloads/#{media_item.id}.mp4", 'wb') do |file|
          file << open("#{media_item.videos.standard_resolution.url}").read
        end
      end
    end
    render html: @html.html_safe
  end
end
