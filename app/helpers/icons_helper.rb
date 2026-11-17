module IconsHelper
  ICONS = {
    alert: [
      "M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0Z",
      "M12 9v4",
      "M12 17h.01"
    ],
    arrow_left: ["M19 12H5", "M12 19l-7-7 7-7"],
    board: [
      "M4 5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2Z",
      "M8 7h8",
      "M8 11h8",
      "M8 15h5"
    ],
    chevron_right: ["m9 18 6-6-6-6"],
    close: ["M18 6 6 18", "M6 6l12 12"],
    image: [
      "M3 5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2Z",
      "M8.5 10a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Z",
      "m21 15-5-5L5 21"
    ],
    moon: ["M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"],
    pencil: ["M12 20h9", "M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"],
    plus: ["M12 5v14", "M5 12h14"],
    sparkles: ["M12 2l2.4 7.6L22 12l-7.6 2.4L12 22l-2.4-7.6L2 12l7.6-2.4Z"],
    sun: [
      "M12 2v2",
      "M12 20v2",
      "m4.93 4.93 1.42 1.42",
      "m17.66 17.66 1.41 1.41",
      "M2 12h2",
      "M20 12h2",
      "m6.34 17.66-1.41 1.41",
      "m19.07 4.93-1.41 1.41",
      "M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8Z"
    ],
    trash: [
      "M3 6h18",
      "M8 6V4h8v2",
      "M19 6l-1 14H6L5 6",
      "M10 11v6",
      "M14 11v6"
    ],
    undo: ["M9 14 4 9l5-5", "M4 9h10a6 6 0 0 1 0 12h-3"]
  }.freeze

  SVG_DEFAULTS = {
    xmlns: "http://www.w3.org/2000/svg",
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    "stroke-width": 1.8,
    "stroke-linecap": "round",
    "stroke-linejoin": "round",
    aria: { hidden: "true" },
    focusable: "false"
  }.freeze

  def icon(name, size: 18, css_class: nil, **)
    tag.svg(**SVG_DEFAULTS, width: size, height: size, class: icon_class(css_class), **) do
      safe_join(ICONS.fetch(name.to_sym).map { |path| tag.path(d: path) })
    end
  end

  private

  def icon_class(css_class)
    ["icon", css_class].compact.join(" ")
  end
end
