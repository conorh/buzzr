require 'rubygems'
require 'buzzr'

feed_url = Buzzr::Feed.discover(ARGV[0])
feed = Buzzr::Feed.retrieve(feed_url)

feed.entries.each do |entry|
  puts "Title: #{entry.title}"
  puts "Author: #{entry.author.name}"
  puts "Comment Count: #{entry.comment_count}"
  puts "Content"
  puts entry.content
  puts

  if entry.urls.length > 0
    puts "Links"
    entry.urls.each {|u| puts "URI: #{u}" }
    puts
  end

  if entry.images.length > 0
    puts "Images"
    entry.images.each {|i| puts "URI: #{i}" }
    puts
  end

  if entry.videos.length > 0
    puts "Videos"
    entry.videos.each {|v| puts "URI: #{v}" }
    puts
  end

  if entry.comment_count > 0
    puts "Comments"
    puts
    entry.comments.each do |comment|
      puts "Author: #{comment.author.name}"
      puts "#{comment.content}"
      puts
    end
  end
  puts "------"
  puts
end