class DrawBox {
  constructor(canvas, options = {}) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.options = {
      lineWidth: options.lineWidth || 5,
      lineCap: options.lineCap || 'round',
      lineJoin: options.lineJoin || 'round',
      strokeStyle: options.strokeStyle || 'black',
      colors: options.colors || ['black', 'red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet'],
      showClear: options.showClear !== false,
      clearLabel: options.clearLabel || 'Clear Canvas',
      caption: options.caption || ''
    };

    this.drawing = false;
    this.x = 0;
    this.y = 0;
    this.prevX = false;
    this.prevY = false;
    this.svgPath = '';
    this.inside = false;

    this.init();
  }

  init() {
    this.canvas.style.cursor = 'pointer';
    this.ctx.lineWidth = this.options.lineWidth;
    this.ctx.lineCap = this.options.lineCap;
    this.ctx.lineJoin = this.options.lineJoin;
    this.ctx.strokeStyle = this.options.strokeStyle;

    const controls = document.createElement('div');
    controls.id = this.canvas.id + '-controls';
    controls.style.width = this.canvas.width + 'px';

    if (this.options.colorSelector) {
      const colorsDiv = document.createElement('div');
      colorsDiv.id = this.canvas.id + '-colors';
      colorsDiv.style.float = 'left';

      this.options.colors.forEach((color, index) => {
        const colorBtn = document.createElement('div');
        colorBtn.style.height = '16px';
        colorBtn.style.width = '16px';
        colorBtn.style.backgroundColor = color;
        colorBtn.style.margin = '2px';
        colorBtn.style.float = 'left';
        colorBtn.style.border = index === 0 ? '2px solid #000' : '2px solid transparent';
        colorBtn.style.cursor = 'pointer';
        if (index === 0) colorBtn.classList.add('selected');

        colorBtn.addEventListener('click', () => {
          colorsDiv.querySelectorAll('div').forEach(div => {
            div.style.borderColor = 'transparent';
            div.classList.remove('selected');
          });
          colorBtn.style.borderColor = '#000';
          colorBtn.classList.add('selected');
          this.ctx.strokeStyle = color;
        });

        colorsDiv.appendChild(colorBtn);
      });

      controls.appendChild(colorsDiv);
    }

    if (this.options.showClear) {
      const clearBtn = document.createElement('button');
      clearBtn.id = this.canvas.id + '-clear';
      clearBtn.textContent = this.options.clearLabel;
      clearBtn.style.float = 'right';
      clearBtn.style.cursor = 'pointer';

      clearBtn.addEventListener('click', (e) => {
        e.preventDefault();
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        const dataInput = document.getElementById(this.canvas.id + '-data');
        if (dataInput) dataInput.value = '';
      });

      controls.appendChild(clearBtn);

      const br = document.createElement('br');
      br.style.clear = 'both';
      controls.appendChild(br);
    }

    this.canvas.parentNode.insertBefore(controls, this.canvas.nextSibling);

    const dataInput = document.createElement('input');
    dataInput.type = 'hidden';
    dataInput.id = this.canvas.id + '-data';
    dataInput.name = this.canvas.id + '-data';
    this.canvas.parentNode.insertBefore(dataInput, controls.nextSibling);

    this.setupEvents();
  }

  setupEvents() {
    this.canvas.addEventListener('mousedown', (e) => this.startDrawing(e));
    this.canvas.addEventListener('mousemove', (e) => this.drawingMove(e));
    this.canvas.addEventListener('mouseup', () => this.stopDrawing());
    this.canvas.addEventListener('mouseout', () => this.stopDrawing());

    this.canvas.addEventListener('touchstart', (e) => this.startDrawing(e));
    this.canvas.addEventListener('touchmove', (e) => this.drawingMove(e));
    this.canvas.addEventListener('touchend', () => this.stopDrawing());
    this.canvas.addEventListener('touchcancel', () => this.stopDrawing());
  }

  getPosition(e) {
    const rect = this.canvas.getBoundingClientRect();
    let clientX, clientY;

    if (e.touches && e.touches.length > 0) {
      clientX = e.touches[0].clientX;
      clientY = e.touches[0].clientY;
    } else {
      clientX = e.clientX;
      clientY = e.clientY;
    }

    if (this.prevX !== false) {
      this.prevX = this.x;
      this.prevY = this.y;
    }

    this.x = clientX - rect.left;
    this.y = clientY - rect.top;

    return { x: this.x, y: this.y };
  }

  startDrawing(e) {
    e.preventDefault();
    this.drawing = true;
    this.inside = false;
    this.prevX = false;
    this.prevY = false;

    const pos = this.getPosition(e);

    const selectedColor = document.querySelector(`#${this.canvas.id}-colors .selected`);
    if (selectedColor) {
      this.ctx.strokeStyle = selectedColor.style.backgroundColor;
    }

    this.ctx.beginPath();
    this.ctx.moveTo(pos.x, pos.y);

    this.svgPath = '<polyline points="';
  }

  drawingMove(e) {
    if (!this.drawing) return;

    e.preventDefault();
    const pos = this.getPosition(e);

    if (this.prevX === false) {
      this.x = this.x + 1;
      this.y = this.y + 1;
    }

    this.ctx.lineTo(pos.x, pos.y);
    this.ctx.stroke();

    this.svgPath += ' ' + pos.x + ',' + pos.y;

    if (pos.x > 0 && pos.x <= this.canvas.width && pos.y > 0 && pos.y <= this.canvas.height) {
      this.inside = true;
    }
  }

  stopDrawing() {
    if (!this.drawing) return;
    this.drawing = false;

    if (this.inside) {
      this.svgPath += `" style="fill:none;stroke:${this.ctx.strokeStyle};stroke-width:${this.ctx.lineWidth}" /></svg>`;

      const dataInput = document.getElementById(this.canvas.id + '-data');
      let svgData = dataInput ? dataInput.value : '';

      if (svgData === '') {
        svgData = `<?xml version="1.0" standalone="no"?><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg width="${this.canvas.width}" height="${this.canvas.height}" version="1.1" xmlns="http://www.w3.org/2000/svg"></svg>`;
      }

      if (dataInput) {
        dataInput.value = svgData.substring(0, svgData.length - 6) + this.svgPath;
      }
    }
  }
}

function initDrawBox() {
  const drawbox = document.getElementById('drawbox');
  if (drawbox) {
    new DrawBox(drawbox, {
      caption: 'This is a caption',
      lineWidth: 5,
      lineCap: 'round',
      lineJoin: 'round',
      colorSelector: true,
      showClear: true
    });
  }
}
