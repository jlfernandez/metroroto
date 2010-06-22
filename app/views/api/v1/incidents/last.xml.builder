xml.instruct!

xml.incidents do
  @incidents.each do |ii|
    xml.incident(:line => ii.line.number, :station => ii.station.name,
      :lat => ii.lat, :long => ii.long, :date => ii.date,
      :twitter_user => ii.user, :source => ii.source, :comment => ii.comment)
  end
end

