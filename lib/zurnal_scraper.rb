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
    temp = doc.css('.temp').first.text.gsub("°", "").strip
    windspeed = "10-30"
    cloudiness = doc.xpath('//*[@id="web"]/div[3]/div/div[2]/div[1]/div[2]/div[2]/div').text.gsub("Verjetnost sneženja:", "").gsub("0-", "").gsub("%", "").strip
    description_icon = #?
    description_string = #?

    
  end
end