json.array! @evt do |evt|
  json.call(evt, :id, :kind, :occurred_on, :location, :line_up_date)

  json.artists evt.artists do |artist|
    json.id artist.id
    json.name artist.name
    json.member_quantity artist.member_quantity
    json.genre artist.genre.name
    json.note artist.note
  end

  json.genres evt.genres.uniq do |genre|
    json.id genre.id
    json.name genre.name
  end
end
