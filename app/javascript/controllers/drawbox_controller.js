import { Controller } from "@hotwired/stimulus"

const DEFAULT_COLORS = [
  "#6cb6ff",
  "#f87171",
  "#4ade80",
  "#facc15",
  "#c084fc",
  "#fb923c",
  "#22d3ee",
  "#f8fafc"
]

const DEFAULT_SIZES = [2, 4, 6, 8]
const MAX_HISTORY = 20
const SVG_NS = "http://www.w3.org/2000/svg"

// Ready-made line/fill icons that can be stamped onto the canvas.
const STAMPS = {
  star: {
    label: "Star",
    fill: true,
    paths: ["M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"]
  },
  heart: {
    label: "Heart",
    fill: true,
    paths: ["M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"]
  },
  sparkles: {
    label: "Sparkles",
    fill: true,
    paths: [
      "M12 2l1.8 5.7L19.5 9.5l-5.7 1.8L12 17l-1.8-5.7L4.5 9.5l5.7-1.8z",
      "M19 15l.9 2.6L22.5 18.5l-2.6.9L19 22l-.9-2.6L15.5 18.5l2.6-.9z"
    ]
  },
  bolt: {
    label: "Bolt",
    fill: true,
    paths: ["M13 2 3 14h9l-1 8 10-12h-9l1-8z"]
  },
  smile: {
    label: "Smiley",
    paths: [
      "M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0z",
      "M8 14s1.5 2 4 2 4-2 4-2",
      "M9 9h.01",
      "M15 9h.01"
    ]
  },
  sun: {
    label: "Sun",
    paths: [
      "M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z",
      "M12 2v2",
      "M12 20v2",
      "M4.93 4.93l1.42 1.42",
      "M17.66 17.66l1.41 1.41",
      "M2 12h2",
      "M20 12h2",
      "M6.34 17.66l-1.41 1.41",
      "M19.07 4.93l-1.41 1.41"
    ]
  },
  cloud: {
    label: "Cloud",
    paths: ["M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9z"]
  },
  music: {
    label: "Music",
    paths: [
      "M9 18V5l12-2v13",
      "M6 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6z",
      "M18 19a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"
    ]
  }
}

export default class extends Controller {
  static targets = ["canvas", "input", "toolbar"]
  static values = {
    colors: { type: Array, default: DEFAULT_COLORS },
    sizes: { type: Array, default: DEFAULT_SIZES },
    restoreUrl: String
  }

  connect() {
    this.ctx = this.canvasTarget.getContext("2d")
    this.ctx.lineCap = "round"
    this.ctx.lineJoin = "round"

    this.drawing = false
    this.hasContent = false
    this.history = []
    this.colorButtons = []
    this.stampButtons = []
    this.currentColor = this.colorsValue[0]
    this.currentSize = this.sizesValue[1] || this.sizesValue[0]
    this.tool = "pen"
    this.currentStamp = "star"

    this.bindEvents()
    this.renderToolbar()
    this.restoreImage()
  }

  disconnect() {
    this.unbindEvents()
  }

  renderToolbar() {
    const tools = document.createElement("div")
    tools.className = "drawbox-group"
    tools.setAttribute("role", "group")
    tools.setAttribute("aria-label", "Drawing tools")

    this.penButton = this.createToolButton("Pen", "Pen tool", () => this.selectTool("pen"))
    this.eraserButton = this.createToolButton("Eraser", "Eraser tool", () => this.selectTool("eraser"))
    tools.append(this.penButton, this.eraserButton)

    const stamps = document.createElement("div")
    stamps.className = "drawbox-group"
    stamps.setAttribute("role", "group")
    stamps.setAttribute("aria-label", "Stamps")

    Object.entries(STAMPS).forEach(([name, stamp]) => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = "stamp-btn"
      button.title = `${stamp.label} stamp`
      button.setAttribute("aria-label", `${stamp.label} stamp`)
      button.setAttribute("aria-pressed", "false")
      button.append(this.svgIcon(stamp.paths))
      button.addEventListener("click", () => this.selectTool("stamp", name))
      stamps.append(button)
      this.stampButtons.push({ name, button })
    })

    const colors = document.createElement("div")
    colors.className = "drawbox-group"
    colors.setAttribute("role", "group")
    colors.setAttribute("aria-label", "Brush color")

    this.colorsValue.forEach((color, index) => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = "color-btn"
      button.dataset.color = color
      button.dataset.tone = String(index)
      button.title = color
      button.setAttribute("aria-label", `Use color ${color}`)
      button.setAttribute("aria-pressed", "false")
      button.addEventListener("click", () => this.selectColor(color, button))
      colors.append(button)
      this.colorButtons.push(button)
    })

    this.customColorInput = document.createElement("input")
    this.customColorInput.type = "color"
    this.customColorInput.className = "color-custom"
    this.customColorInput.value = this.currentColor
    this.customColorInput.title = "Custom color"
    this.customColorInput.setAttribute("aria-label", "Choose a custom brush color")
    this.customColorInput.addEventListener("input", () => this.selectColor(this.customColorInput.value, this.customColorInput))
    colors.append(this.customColorInput)

    const sizes = document.createElement("div")
    sizes.className = "drawbox-group"
    sizes.setAttribute("role", "group")
    sizes.setAttribute("aria-label", "Brush size")

    this.sizeButtons = []
    this.sizesValue.forEach((size) => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = "size-btn"
      button.dataset.size = String(size)
      button.title = `Size ${size}`
      button.setAttribute("aria-label", `Brush size ${size} pixels`)
      button.setAttribute("aria-pressed", "false")
      button.addEventListener("click", () => this.selectSize(size))
      sizes.append(button)
      this.sizeButtons.push(button)
    })

    const actions = document.createElement("div")
    actions.className = "drawbox-group ml-auto"
    this.undoButton = this.createToolButton("Undo", "Undo last stroke", () => this.undo())
    this.clearButton = this.createToolButton("Clear", "Clear the canvas", () => this.clear())
    actions.append(this.undoButton, this.clearButton)

    this.toolbarTarget.replaceChildren(
      tools,
      this.divider(),
      stamps,
      this.divider(),
      colors,
      this.divider(),
      sizes,
      actions
    )

    this.selectColor(this.currentColor, this.colorButtons[0])
    this.selectSize(this.currentSize)
    this.updateToolbarState()
  }

  divider() {
    const divider = document.createElement("span")
    divider.className = "drawbox-divider"
    divider.setAttribute("aria-hidden", "true")
    return divider
  }

  createToolButton(label, ariaLabel, onClick) {
    const button = document.createElement("button")
    button.type = "button"
    button.className = "tool-btn"
    button.textContent = label
    button.setAttribute("aria-label", ariaLabel)
    button.setAttribute("aria-pressed", "false")
    button.addEventListener("click", onClick)
    return button
  }

  svgIcon(paths) {
    const svg = document.createElementNS(SVG_NS, "svg")
    svg.setAttribute("viewBox", "0 0 24 24")
    svg.setAttribute("fill", "none")
    svg.setAttribute("stroke", "currentColor")
    svg.setAttribute("stroke-width", "1.8")
    svg.setAttribute("stroke-linecap", "round")
    svg.setAttribute("stroke-linejoin", "round")
    svg.setAttribute("aria-hidden", "true")
    svg.setAttribute("focusable", "false")
    svg.classList.add("icon")

    paths.forEach((d) => {
      const path = document.createElementNS(SVG_NS, "path")
      path.setAttribute("d", d)
      svg.append(path)
    })

    return svg
  }

  selectTool(tool, stamp = null) {
    this.tool = tool
    if (stamp) this.currentStamp = stamp

    this.canvasTarget.dataset.tool = tool
    this.updateToolbarState()
  }

  selectColor(color, button) {
    this.currentColor = color

    if (this.tool === "eraser") this.selectTool("pen")

    this.colorButtons.forEach((colorButton) => {
      const active = colorButton === button
      colorButton.classList.toggle("is-active", active)
      colorButton.setAttribute("aria-pressed", String(active))
    })
    this.customColorInput?.classList.toggle("is-active", button === this.customColorInput)
    if (this.customColorInput) this.customColorInput.value = color
  }

  selectSize(size) {
    this.currentSize = size
    this.sizeButtons.forEach((button) => {
      const active = Number(button.dataset.size) === size
      button.classList.toggle("is-active", active)
      button.setAttribute("aria-pressed", String(active))
    })
  }

  restoreImage() {
    const value = this.inputTarget.value.trim()
    if (!value) return

    const source = this.imageSource(value)
    if (!source) return

    const image = new Image()
    image.decoding = "async"
    image.onload = () => {
      this.ctx.drawImage(image, 0, 0, this.canvasTarget.width, this.canvasTarget.height)
      this.hasContent = true
      this.updateInput()
      this.updateToolbarState()
    }
    image.src = source
  }

  imageSource(value) {
    if (value.startsWith("data:")) return value
    if (value.startsWith("iVBOR")) {
      return this.restoreUrlValue || `data:image/png;base64,${value}`
    }

    return this.restoreUrlValue
  }

  bindEvents() {
    this.handlePointerDown = this.pointerDown.bind(this)
    this.handlePointerMove = this.pointerMove.bind(this)
    this.handlePointerUp = this.pointerUp.bind(this)
    this.handleKeyDown = this.keyDown.bind(this)
    this.handleToolbarKeyDown = this.toolbarKeyDown.bind(this)

    this.canvasTarget.addEventListener("pointerdown", this.handlePointerDown)
    this.canvasTarget.addEventListener("pointermove", this.handlePointerMove)
    this.canvasTarget.addEventListener("pointerup", this.handlePointerUp)
    this.canvasTarget.addEventListener("pointercancel", this.handlePointerUp)
    this.element.addEventListener("keydown", this.handleKeyDown)
    this.toolbarTarget.addEventListener("keydown", this.handleToolbarKeyDown)
  }

  unbindEvents() {
    this.canvasTarget.removeEventListener("pointerdown", this.handlePointerDown)
    this.canvasTarget.removeEventListener("pointermove", this.handlePointerMove)
    this.canvasTarget.removeEventListener("pointerup", this.handlePointerUp)
    this.canvasTarget.removeEventListener("pointercancel", this.handlePointerUp)
    this.element.removeEventListener("keydown", this.handleKeyDown)
    this.toolbarTarget.removeEventListener("keydown", this.handleToolbarKeyDown)
  }

  pointerDown(event) {
    if (!event.isPrimary) return
    if (event.pointerType === "mouse" && event.button !== 0) return

    this.canvasTarget.focus({ preventScroll: true })
    event.preventDefault()
    const { x, y } = this.coords(event)

    if (this.tool === "stamp") {
      this.pushHistory()
      this.drawStamp(x, y)
      this.hasContent = true
      this.updateInput()
      this.updateToolbarState()
      return
    }

    this.drawing = true
    this.hasContent = true
    this.canvasTarget.setPointerCapture(event.pointerId)
    this.pushHistory()
    this.applyStrokeStyle()

    this.ctx.beginPath()
    this.ctx.arc(x, y, this.strokeWidth() / 2, 0, Math.PI * 2)
    this.ctx.fill()
    this.ctx.beginPath()
    this.ctx.moveTo(x, y)
  }

  pointerMove(event) {
    if (!this.drawing || !event.isPrimary) return

    event.preventDefault()
    const { x, y } = this.coords(event)

    this.ctx.lineTo(x, y)
    this.ctx.stroke()
  }

  pointerUp(event) {
    if (!this.drawing) return

    this.drawing = false
    this.ctx.closePath()

    if (event.pointerId != null && this.canvasTarget.hasPointerCapture(event.pointerId)) {
      this.canvasTarget.releasePointerCapture(event.pointerId)
    }

    this.updateInput()
    this.updateToolbarState()
  }

  applyStrokeStyle() {
    const erasing = this.tool === "eraser"

    this.ctx.globalCompositeOperation = erasing ? "destination-out" : "source-over"
    this.ctx.strokeStyle = this.currentColor
    this.ctx.fillStyle = this.currentColor
    this.ctx.lineWidth = this.strokeWidth()
  }

  strokeWidth() {
    return this.tool === "eraser" ? this.currentSize * 3 : this.currentSize
  }

  stampSize() {
    return 24 + this.currentSize * 6
  }

  drawStamp(x, y) {
    const stamp = STAMPS[this.currentStamp]
    if (!stamp) return

    const size = this.stampSize()
    const scale = size / 24

    this.ctx.save()
    this.ctx.translate(x - size / 2, y - size / 2)
    this.ctx.scale(scale, scale)
    this.ctx.globalCompositeOperation = "source-over"
    this.ctx.strokeStyle = this.currentColor
    this.ctx.fillStyle = this.currentColor
    this.ctx.lineWidth = Math.max(1.5, this.currentSize * 0.6) / scale
    this.ctx.lineCap = "round"
    this.ctx.lineJoin = "round"

    stamp.paths.forEach((d) => {
      const path = new Path2D(d)
      if (stamp.fill) {
        this.ctx.fill(path)
      } else {
        this.ctx.stroke(path)
      }
    })

    this.ctx.restore()
  }

  keyDown(event) {
    if (!(event.metaKey || event.ctrlKey) || event.key.toLowerCase() !== "z" || event.shiftKey) return

    const target = event.target
    const editingText =
      target instanceof Element &&
      target.closest("textarea, [contenteditable='true'], input:not([type='color'])")
    if (editingText || this.history.length === 0) return

    event.preventDefault()
    this.undo()
  }

  toolbarKeyDown(event) {
    if (!["ArrowLeft", "ArrowRight", "Home", "End"].includes(event.key)) return

    const controls = Array.from(this.toolbarTarget.querySelectorAll("button:not(:disabled)"))
    const index = controls.indexOf(event.target)
    if (index === -1) return

    event.preventDefault()

    if (event.key === "Home") {
      controls[0].focus()
    } else if (event.key === "End") {
      controls.at(-1).focus()
    } else {
      const offset = event.key === "ArrowRight" ? 1 : -1
      controls[(index + offset + controls.length) % controls.length].focus()
    }
  }

  coords(event) {
    const rect = this.canvasTarget.getBoundingClientRect()
    const scaleX = this.canvasTarget.width / rect.width
    const scaleY = this.canvasTarget.height / rect.height

    return {
      x: (event.clientX - rect.left) * scaleX,
      y: (event.clientY - rect.top) * scaleY
    }
  }

  pushHistory() {
    if (this.history.length >= MAX_HISTORY) this.history.shift()
    this.history.push(
      this.ctx.getImageData(0, 0, this.canvasTarget.width, this.canvasTarget.height)
    )
  }

  undo() {
    const snapshot = this.history.pop()
    if (!snapshot) return

    this.ctx.putImageData(snapshot, 0, 0)
    this.hasContent = !this.isBlank()
    this.updateInput()
    this.updateToolbarState()
  }

  clear() {
    if (!this.hasContent) return

    this.pushHistory()
    this.ctx.clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)
    this.hasContent = false
    this.updateInput()
    this.updateToolbarState()
  }

  isBlank() {
    const data = this.ctx.getImageData(
      0,
      0,
      this.canvasTarget.width,
      this.canvasTarget.height
    ).data

    for (let index = 3; index < data.length; index += 4) {
      if (data[index] !== 0) return false
    }

    return true
  }

  updateInput() {
    this.inputTarget.value = this.hasContent
      ? this.canvasTarget.toDataURL("image/png")
      : ""
  }

  updateToolbarState() {
    if (this.undoButton) this.undoButton.disabled = this.history.length === 0
    if (this.clearButton) this.clearButton.disabled = !this.hasContent

    this.penButton?.classList.toggle("is-active", this.tool === "pen")
    this.eraserButton?.classList.toggle("is-active", this.tool === "eraser")
    this.penButton?.setAttribute("aria-pressed", String(this.tool === "pen"))
    this.eraserButton?.setAttribute("aria-pressed", String(this.tool === "eraser"))

    this.stampButtons.forEach(({ name, button }) => {
      const active = this.tool === "stamp" && name === this.currentStamp
      button.classList.toggle("is-active", active)
      button.setAttribute("aria-pressed", String(active))
    })
  }
}
