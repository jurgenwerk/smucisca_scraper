# encoding: UTF-8
require 'nokogiri'
require 'open-uri'

class ZurnalScraper
  def scrape
    urls = urls_to_scrape # ["http://vreme.zurnal24.si/smucisce/bohinj-vogel",...]
    urls.each do |url|
      puts scrape_url(url)
    end    
  end
  
  def urls_to_scrape
    url = "http://vreme.zurnal24.si/smucisca/"
    doc = Nokogiri::HTML(open(url))
    url_list = doc.xpath('//*[@id="main"]/div[1]/div[1]/div/div[*]/a').map do |node|
      relative_url = node.values.first
      URI.join(url, relative_url).to_s
    end
  end

  def scrape_url(url)
    doc = Nokogiri::HTML(open(url))

    name = doc.xpath('//*[@id="web"]/div[3]/div/div[2]/div[1]/div[1]/div[2]/h3').text
    height = doc.css('.humidity').first.text.gsub("m", "").to_i
    snowlevel = doc.css('.gray').first.text.gsub("cm", "").strip
    snowlevel = snowlevel == "/" ? 0 : snowlevel
    temp = doc.css('.temp').first.text.gsub("°", "").strip
    windspeed = "10-30"
    cloudiness = doc.xpath('//*[@id="web"]/div[3]/div/div[2]/div[1]/div[2]/div[2]/div').text.gsub("Verjetnost sneženja:", "").gsub("0-", "").gsub("%", "").strip
    icon_index = doc.xpath('//*[@id="web"]/div[3]/div/div[2]/div[1]/div[1]/div[3]/img').first.values.first.split("=")[1].gsub("&size", "").to_i
    description_icon = icon_mapper[icon_index]
    description = "Sneži fejst" #scrape this from snezni telefon

    tomorrow_morning_temp = doc.css('.temp')[5].text.gsub("°", "").strip
    tomorrow_morning_windspeed = windspeed
    temp_icon_index = doc.css('td.inner .row .small-4 img').first.values.first.split("=")[1].gsub("&size", "").to_i
    tomorrow_morning_icon_index = icon_mapper[temp_icon_index]

    tomorrow_afternoon_temp = doc.css('.temp')[8].text.gsub("°", "").strip
    tomorrow_afternoon_windspeed = windspeed
    temp_icon_index = doc.css('td.inner .row .small-4 img')[3].values.first.split("=")[1].gsub("&size", "").to_i
    tomorrow_afternoon_icon_index = icon_mapper[temp_icon_index]

    tomorrow_date = DateTime.now.tomorrow
    tomorrow_time = day_mapper[tomorrow_date.wday] + " " +  tomorrow_date.day.to_s + "." + tomorrow_date.month.to_s

    puts "name: " + name
    puts "height: " + height.to_s
    puts "snowlevel: " + snowlevel.to_s
    puts "windspeed: " + windspeed.to_s
    puts "cloudiness: " + cloudiness.to_s
    puts "description icon: " + description_icon.to_s
    puts "description: " + description.to_s

    puts "  tomorrow time" + tomorrow_time.to_s
    puts "  tomorrow morning temp: " + tomorrow_morning_temp.to_s
    puts "  tomorrow morning windspeed: " + tomorrow_morning_windspeed.to_s
    puts "  tomorrrow morning icon index: " + tomorrow_morning_icon_index.to_s
    puts "  tomorrow afternoon temp: " + tomorrow_afternoon_temp.to_s
    puts "  tomorrow afternoon windspeed: " + tomorrow_afternoon_windspeed.to_s
    puts "  tomorrrow afternoon icon index: " + tomorrow_afternoon_icon_index.to_s

  end

  def day_mapper
    @day_mapper ||=
    {
      0 => "Nedelja",
      1 => "Ponedeljek",
      2 => "Torek",
      3 => "Sreda",
      4 => "Četrtek",
      5 => "Petek",
      6 => "Sobota"
    }
  end

  def icon_mapper
    @icon_mapper ||= 
    { 1 => 0,
      2 => 3,
      3 => 13,
      4 => 8,
      5 => 8,
      6 => 5,
      7 => 5,
      8 => 5,
      9 => 7, 
      10 => 7,
      11 => 7,
      12 => 9,
      13 => 9,
      14 => 9,
      15 => 1
    }
  end

  #zurnal - meaning - client
  #1 - sunny - 0
  #2 - partly sunny - 3,4
  #3 - partly cloudy - 13
  #4 - cloudy -8
  #5 - cloudy -8
  #6 - rainy - 5, 6, 
  #7 - rainy - 5, 6, 
  #8 - rainy - 5, 6, 
  #9 - rain and snow - 7
  #10 - same -7
  #11 - same - 7
  #12 - snow - 9, 10, 11
  #13 - ice, snow - 9
  #14 - same - 9
  #15 - megla - 1,2

end


# if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"0"]) 
#         return [UIImage imageNamed:@"clear.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"1"]) 
#         return [UIImage imageNamed:@"fog.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"2"]) 
#         return [UIImage imageNamed:@"fog.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"3"])
#         return [UIImage imageNamed:@"partlycloudy.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"4"])
#         return [UIImage imageNamed:@"partlycloudy.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"5"])
#         return [UIImage imageNamed:@"partysunnyrain.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"6"])
#         return [UIImage imageNamed:@"flurries.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"7"])
#         return [UIImage imageNamed:@"flurries.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"8"])
#         return [UIImage imageNamed:@"scatteredclouds.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"9"])
#         return [UIImage imageNamed:@"cloundysnow.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"10"])
#         return [UIImage imageNamed:@"cloundysnow.png"];
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"11"])
#         return [UIImage imageNamed:@"cloundysnow.png"];
    
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"12"])
#         return [UIImage imageNamed:@"cloundysnow.png"];
    
#     else if ([[NSString stringWithFormat:@"%@", description] isEqualToString:@"13"])
#         return [UIImage imageNamed:@"partlysunny.png"];


# if (weatherDescS == "jasno" || weatherDescS == "sončno" )
#                     weather.Description = 0;
#                 else if (weatherDescS.Contains("megl"))
#                     weather.Description = (Weather.WeatherState)2;
#                 else if (weatherDescS == "oblačno")
#                     weather.Description = (Weather.WeatherState)8;
#                 else if (weatherDescS.Contains("sneg") || weatherDescS.Contains("snež"))
#                     weather.Description = (Weather.WeatherState)10;
#                 else if (weatherDescS.Contains("prete") && weatherDescS.Contains("obla"))
#                     weather.Description = (Weather.WeatherState)13;
#                 else if (weatherDescS.Contains("prete") && weatherDescS.Contains("jasno"))
#                     weather.Description = (Weather.WeatherState)4;
#                 else if (weatherDescS.Contains("deln") && weatherDescS.Contains("obla"))
#                     weather.Description = (Weather.WeatherState)4;
#                 else if (weatherDescS.Contains("deln") && weatherDescS.Contains("jasn"))
#                    weather.Description = (Weather.WeatherState)4;