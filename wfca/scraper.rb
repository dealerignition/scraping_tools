require 'open-uri'
require 'nokogiri'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

print "Name\tContact\tMailing\tCity\tState\tPostal\tPhone\tFax\tWebsite\tCategory\tBusiness Category\n"

(0..79).each do |limit_start|
  limit_start *= 20
  page = Nokogiri::HTML(open("https://wfca.memberclicks.net/index.php?option=com_community&view=search&searchId=54917&uuId=50506e7e6246e&limitstart=#{limit_start}"))
  dealers = page.xpath("//div[@class='mini-profile-details']")

  i = 0

  dealers.each do |dealer|
    name = ""
    contact = ""
    mailing = ""
    city = ""
    state = ""
    postal = ""
    phone = ""
    fax = ""
    website = ""
    category = ""
    business_type = ""
    
    begin
      sub_page = "http://wfca.memberclicks.net#{dealer.xpath("//h3[@class='name']/a")[i].attributes["href"]}"
      sub_page = Nokogiri::HTML(open(sub_page))
      sub_page = sub_page.xpath("//dl[@class='profile-right-info']").to_s

      name = dealer.xpath("//div[@class='searchTemplateRow1']")[i].inner_text
      name.strip!
      contact = dealer.xpath("//div[@class='searchTemplateRow2']")[i].inner_text
      contact.strip!
      mailing = dealer.xpath("//div[@class='searchTemplateRow6']")[i].inner_text
      mailing.strip!
      city = dealer.xpath("//div[@class='searchTemplateRow7']")[i].inner_text
      city.strip!
      city = city.scan(/([A-Z ]* )/)[0][0]
      city.strip!
      state = dealer.xpath("//div[@class='searchTemplateRow7']")[i].inner_text
      state.strip!
      state = state.scan(/(([A-Z][a-z]+ )+)/)
      if state != []
        state = state[0][0]
      else
        state = city.scan(/([A-Z]+\z)/)[0][0]
        city = city.gsub(state, "")
        city.strip!
      end
      state.strip!
      postal = dealer.xpath("//div[@class='searchTemplateRow7']")[i].inner_text
      postal.strip!
      postal = postal.scan(/(([0-9]|[A-Z][0-9])[0-9A-Z\s]+\z)/)[0][0]
      postal.strip!
      
      phone = dealer.xpath("//div[@class='searchTemplateRow3']")[i].inner_text
      phone.strip!
      phone = phone.scan(/([0-9\-\(\)\s]+)/)[0][0]
      phone.strip!
      
      fax = dealer.xpath("//div[@class='searchTemplateRow4']")[i].inner_text
      fax.strip!
      fax = phone.scan(/([0-9\-\(\)\s]+)/)[0][0]
      fax.strip!
      
      website = dealer.xpath("//div[@class='searchTemplateRow5']/a")[i].inner_text
      website.strip!

      if "#{sub_page.scan(/Category/)}" != "[]"
        category = sub_page.scan(/<dt>Category:<\/dt>[^<]*<dd>([^<]*)<\/dd>/)[0][0] 
      end
      if "#{sub_page.scan(/Business Type/)}" != "[]"
        business_type = sub_page.scan(/<dt>Business Type:<\/dt>[^<]*<dd>([^<]*)<\/dd>/)[0][0]
      end

      print "#{name.gsub(/\n/, ",")}\t#{contact.gsub(/\n/, ",")}\t#{mailing.gsub(/\n/, ",")}\t#{city.gsub(/\n/, ",")}\t#{state.gsub(/\n/, ",")}\t#{postal.gsub(/\n/, ",")}\t#{phone.gsub(/\n/, ",")}\t#{fax.gsub(/\n/, ",")}\t#{website.gsub(/\n/, ",")}\t#{category}\t#{business_type}\n"
    rescue => e
      puts e
    end
    i = i + 1
  end
end
