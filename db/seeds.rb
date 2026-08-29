%w[General Music].each do |title|
  Board.find_or_create_by!(title: title)
end
