module Buzzr
  class FeedEntry
    attr :atom_entry
    attr :atom_replies

    # Expects an Atom::Entry object
    def initialize(atom_entry)
      @atom_entry = atom_entry
    end

    def [](name)
      @atom_entry.send(name)
    end

    def method_missing(method, *args, &block)
      @atom_entry.send(method)
    end

    def fetch_comments
      @comments = nil
      link = @atom_entry.links.find {|l| l.rel == 'replies'}
      @atom_replies = Atom::Feed.load_feed(URI.parse(link.href)) if link
    end

    def comments
      return @comments if @comments
      fetch_comments if @atom_replies.nil?
      @comments = @atom_replies.entries.collect {|r| FeedReply.new(r) }
    end

    def comment_count
      return @comments.length if @comments
      @atom_entry["http://purl.org/syndication/thread/1.0","total"][0].to_i
    end
    
    def urls
      @links ||= @atom_entry.links.find_all {|l| l.type =~ %r{text/html}i }.collect {|l| l.href}
    end

    def images
      @images ||= @atom_entry.links.find_all {|l| l.type =~ /image/i }.collect {|l| l.href}
    end

    def videos
      @videos ||= @atom_entry.links.find_all {|l| l.type =~ %r{application/x-shockwave-flash}i }.collect {|l| l.href}
    end

    def author
      @atom_entry.authors[0] if @atom_entry.respond_to?(:authors)
    end
  end
end