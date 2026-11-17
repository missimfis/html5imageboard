%w[General Music Sketches].each do |title|
  Board.find_or_create_by!(title: title)
end

Rails.logger.info "Seeded #{Board.count} boards."
