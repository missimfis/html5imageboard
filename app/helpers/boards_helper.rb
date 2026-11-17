module BoardsHelper
  AVATAR_TONES = %w[
    from-sky-400 to-indigo-500
    from-rose-400 to-orange-500
    from-violet-400 to-fuchsia-500
    from-emerald-400 to-teal-500
    from-amber-400 to-orange-600
    from-cyan-400 to-blue-500
    from-pink-400 to-rose-600
    from-lime-400 to-emerald-600
  ].freeze

  def board_avatar_tone(board)
    tone = board.title.to_s.each_byte.sum % AVATAR_TONES.length

    AVATAR_TONES[tone]
  end
end
