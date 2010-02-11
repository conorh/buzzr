module Buzzr
  class FeedError < Exception; end;

  class Feed
    attr :feed_url
    attr :atom_feed

    def initialize(feed_url, options = {})
      @feed_url = feed_url
    end
    
    def self.retrieve(feed_url)
      feed = Feed.new(feed_url)
      feed.fetch
      feed
    end

    # Extract the feed url from the users's google profile page
    def self.discover(profile_name)
      begin
        page = open("http://www.google.com/profiles/#{profile_name}").read
      rescue OpenURI::HTTPError => e
        if e.io.status[0] == '404'
          raise FeedError, "Could not find profile for #{profile_name} at - http://www.google.com/profiles/#{profile_name}"
        end
      end
      
      if match = page.match(%r{<link rel="alternate" type="application/atom\+xml" href="([^"]+)})
        match[1]
      else
        raise FeedError, "Could not find atom feed on profile page"
      end
    end
    
    # Retrieve and parse the buzz atom feed
    def fetch
      @feed_entries = nil
      @atom_feed = Atom::Feed.load_feed(URI.parse(@feed_url))
    end
    
    # Retrieve the entries in the buzz atom feed as an array of FeedEntry objects
    # This will fetch the feed if it has not already been fetched
    def entries
      return @feed_entries if @feed_entries
      fetch if @atom_feed.nil?
      @feed_entries = @atom_feed.entries.collect {|e| FeedEntry.new(e) }
    end
  end
end