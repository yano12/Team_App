#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title Settings.title
    xml.description Settings.description
    xml.link Settings.url
    @microposts.each do |micropost|
      xml.item do
        xml.title micropost.id
        xml.description micropost.content
        xml.pubDate micropost.created_at
        xml.guid micropost_path(micropost)
        xml.link micropost_path(micropost)
      end
    end
  end
end