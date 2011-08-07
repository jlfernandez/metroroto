class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout "metroroto"
  before_filter :load_lines

  def collection_to_feed(collection, options = {})
    feed = Atom::Feed.new
    url_params = params.clone
    url_params.delete(:format)
    feed.links << Atom::Link.new(:rel => 'alternate',
    :href => url_for(url_params)) 
    collection.each do |item|
      item_options = item.options_for_feed
      feed_item = Atom::Entry.new
      feed_item.title = item_options[:title]
      feed_item.links << Atom::Link.new(:rel =>'alternate',
      :href => url_for(Incident.find(item_options[:id])))
      feed_item.summary = item_options[:excerpt]
      feed_item.content =  Atom::Content::Html.new(item_options[:content])
      feed_item.published = item_options[:date]
      feed_item.updated = item_options[:date]
      feed_item.id = item_options[:id]
      feed.entries << feed_item
    end
    return feed
  end

  private

  def load_lines
    @lines = Line.all
  end

end
