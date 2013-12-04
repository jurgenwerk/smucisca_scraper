
require 'ostruct'

amespace :scraper do
  task scrape: :environment do
    current_weather = OpenStruct.new
    forecast = OpenStruct.new
    today_morning = OpenStruct.new
    today_afternoon = OpenStruct.new
    tomorrow_morning = OpenStruct.new
    tomorrow_afternoon = OpenStruct.new

    



    forecast.todayMorning = today_morning
    forecast.todayAfternoon = today_afternoon
    forecast.tomorrowMorning = tomorrow_morning
    forecast.tomorrowAfternoon = tomorrow_afternoon
    current_weather.forecast = forecast
    #gsub!(/\"/, '\'')
  end
end
