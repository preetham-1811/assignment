class Ps1Controller < ApplicationController

  def home
    # if user_signed_in?
    #   if current_user.is_admin?
    #     redirect_to examscheduler_admin_path
    #   end
    # end
  end

  def ps1
  end

  def dbz
    logger.error "About to divide by 0\n"
    @number = 7/0
  end

  def article
    require 'open-uri'
    require 'nokogiri'

    # ##################################
    # open the URL for Foxnews
    # # ##################################
    begin
    html= URI.open("https://www.foxnews.com/", proxy: URI.parse("http://192.41.170.23:3128"))
    rescue Net::OpenTimeout => exception
      html= URI.open("https://www.foxnews.com/")
    end
    response = Nokogiri::HTML(html)


    # get the heading
    @foxnews_heading = response.css("main header a")[0].text
    # puts @foxnews_heading

    # get the image URL
    @foxnews_img = response.css("img").find{|picture|picture.attributes["alt"].value.include?(@foxnews_heading)}.attributes["src"].value
    @foxnews_img = @foxnews_img[2..-1]
    # puts @foxnews_img

    @foxnews_url =  response.css("main header a").map { |anchor| anchor["href"] }[0]
    # puts @foxnews_url

    # ##################################
    # open the URL for nationthailand
    # ##################################
    begin
    html= URI.open("https://www.nationthailand.com/", proxy: URI.parse("http://192.41.170.23:3128"))
    rescue Net::OpenTimeout => exception
      html= URI.open("https://www.nationthailand.com/")
    end
    response = Nokogiri::HTML(html)

    @nationTH_url =  response.css(".flexslider a").map { |anchor| anchor["href"] }[0]
    # puts @nationTH_url

    @imgID  = URI(@nationTH_url)
    @imgID  = @imgID.path.split("/")[2]
    # puts @imgID

    # get the heading
    @nationTH_heading = response.css(".slides .slide-cap h2")[0].text
    # puts @nationTH_heading
    #
    # get the image URL
    @nationTH_img = response.css(".slides .slide-pic img").map { |anchor| anchor["src"] }
    @i = 0
    loop do
      if @i == @nationTH_img.length
        break
      end
      if @nationTH_img[@i].include? @imgID
        @nationTH_img = @nationTH_img[@i]
        break
      end
      @i += 1
    end

  end
end
