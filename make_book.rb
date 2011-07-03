require 'open-uri'
require 'nokogiri'

index_urls = {
  "Volume One" => "http://press.uchicago.edu/books/HOC/HOC_V1/Volume1.html",
  "Volume Two, Book One" => "http://press.uchicago.edu/books/HOC/HOC_V2_B1/Volume2_Book1.html",
  "Volume Two, Book Two" => "http://press.uchicago.edu/books/HOC/HOC_V2_B2/Volume2_Book2.html",
  "Volume Two, Book Three" => "http://press.uchicago.edu/books/HOC/HOC_V2_B3/Volume2_Book3.html"
}
base_urls = {
  "Volume One" => "http://press.uchicago.edu/books/HOC/HOC_V1/",
  "Volume Two, Book One" => "http://press.uchicago.edu/books/HOC/HOC_V2_B1/",
  "Volume Two, Book Two" => "http://press.uchicago.edu/books/HOC/HOC_V2_B2/",
  "Volume Two, Book Three" => "http://press.uchicago.edu/books/HOC/HOC_V2_B3/"
}


index_urls.each do |name, url|
  `mkdir "#{name}"`
  html_doc = Nokogiri::HTML(open(url))
  pdf_list = []
  html_doc.css('a[href$="pdf"]').map { |link|
    system("wget -P \"#{name}\" #{ base_urls[name] + link['href'] }")
    pdf_list.push("\"#{name}/#{link['href']}\"")
  }

  pdf_list_str = pdf_list.join(" ")
  system("pdftk #{pdf_list_str} output '#{name}.pdf'")
end
