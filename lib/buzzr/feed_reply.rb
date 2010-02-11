module Buzzr
  class FeedReply
    attr :atom_entry
    
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

    def author
      @atom_entry.authors[0] if @atom_entry.respond_to?(:authors)
    end
  end
end