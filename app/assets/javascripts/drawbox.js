class DrawBox {
  constructor(canvas, options = {}) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.options = {
      lineWidth: options.lineWidth || 3,
      lineCap: options.lineCap || 'round',
      lineJoin: options.lineJoin || 'round',
      strokeStyle: options.strokeStyle || '#58a6ff',
      colors: options.colors || ['#58a6ff', '#f85149', '#3fb950', '#d29922', '#a371f7', '#ff7b72', '#79c0ff', '#ffffff'],
      showClear: options.showClear !== false,
      clearLabel: options.clearLabel || 'Clear',
      sizes: options.sizes || [2, 4, 6, 8],
      loadImageUrl: options.loadImageUrl || null,
      existingData: options.existingData || null
    };

    this.drawing = false;
    this.lastX = 0;
    this.lastY = 0;
    this.currentColor = this.options.colors[0];
    this.currentSize = this.options.lineWidth;

    this.init();
  }

  init() {
    this.ctx.lineCap = 'round';
    this.ctx.lineJoin = 'round';
    this.ctx.strokeStyle = this.currentColor;
    this.ctx.lineWidth = this.currentSize;

    const container = document.createElement('div');
    container.className = 'drawbox-container';

    this.createToolbar(container);
    this.createCanvas(container);

    this.canvas.parentNode.insertBefore(container, this.canvas);
    container.appendChild(this.canvas);

    this.loadExistingImage();
    this.setupEvents();
    this.setupToggle();
  }

  loadExistingImage() {
    if (this.options.existingData) {
      const img = new Image();
      img.onload = () => {
        this.ctx.drawImage(img, 0, 0);
      };
      if (this.options.existingData.startsWith('data:')) {
        img.src = this.options.existingData;
      } else if (this.options.loadImageUrl) {
        img.src = this.options.loadImageUrl;
      }
    }
  }

  createToolbar(container) {
    const toolbar = document.createElement('div');
    toolbar.className = 'drawbox-toolbar';

    const colorPalette = document.createElement('div');
    colorPalette.className = 'color-palette';

    this.options.colors.forEach((color, index) => {
      const colorBtn = document.createElement('button');
      colorBtn.type = 'button';
      colorBtn.className = 'color-btn' + (index === 0 ? ' active' : '');
      colorBtn.style.backgroundColor = color;
      colorBtn.title = color;
      colorBtn.dataset.color = color;

      colorBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        colorPalette.querySelectorAll('.color-btn').forEach(b => b.classList.remove('active'));
        colorBtn.classList.add('active');
        this.currentColor = color;
        this.ctx.strokeStyle = color;
      });

      colorPalette.appendChild(colorBtn);
    });

    const sizePalette = document.createElement('div');
    sizePalette.className = 'size-palette';

    this.options.sizes.forEach(size => {
      const sizeBtn = document.createElement('button');
      sizeBtn.type = 'button';
      sizeBtn.className = 'size-btn';
      sizeBtn.style.width = size + 6 + 'px';
      sizeBtn.style.height = size + 6 + 'px';
      sizeBtn.title = 'Size ' + size;
      sizeBtn.dataset.size = size;

      sizeBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        sizePalette.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
        sizeBtn.classList.add('active');
        this.currentSize = size;
        this.ctx.lineWidth = size;
      });

      sizePalette.appendChild(sizeBtn);
    });

    const clearBtn = document.createElement('button');
    clearBtn.type = 'button';
    clearBtn.className = 'clear-btn';
    clearBtn.textContent = this.options.clearLabel;
    clearBtn.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
      this.updateData();
    });

    toolbar.appendChild(colorPalette);
    toolbar.appendChild(sizePalette);
    toolbar.appendChild(clearBtn);
    container.appendChild(toolbar);
  }

  createCanvas(container) {
    this.canvas.style.cursor = 'crosshair';
    this.canvas.style.display = 'block';
    this.canvas.style.backgroundColor = '#1c2128';
    this.canvas.style.borderRadius = '8px';
  }

  setupToggle() {
    const toggleBtn = document.getElementById('new_post_button');
    const form = document.getElementById('new_post_form');
    if (toggleBtn && form) {
      toggleBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        const isHidden = form.style.display === 'none';
        form.style.display = isHidden ? 'block' : 'none';
        toggleBtn.textContent = isHidden ? 'Cancel' : '+ Add Post';
      });
    }
  }

  setupEvents() {
    this.canvas.addEventListener('mousedown', (e) => this.start(e));
    this.canvas.addEventListener('mousemove', (e) => this.move(e));
    this.canvas.addEventListener('mouseup', () => this.end());
    this.canvas.addEventListener('mouseleave', () => this.end());

    this.canvas.addEventListener('touchstart', (e) => {
      e.preventDefault();
      this.start(e.touches[0]);
    });
    this.canvas.addEventListener('touchmove', (e) => {
      e.preventDefault();
      this.move(e.touches[0]);
    });
    this.canvas.addEventListener('touchend', () => this.end());
  }

  getCoords(e) {
    const rect = this.canvas.getBoundingClientRect();
    const scaleX = this.canvas.width / rect.width;
    const scaleY = this.canvas.height / rect.height;

    return {
      x: (e.clientX - rect.left) * scaleX,
      y: (e.clientY - rect.top) * scaleY
    };
  }

  start(e) {
    this.drawing = true;
    const coords = this.getCoords(e);
    this.lastX = coords.x;
    this.lastY = coords.y;

    this.ctx.strokeStyle = this.currentColor;
    this.ctx.lineWidth = this.currentSize;
    this.ctx.beginPath();
    this.ctx.moveTo(coords.x, coords.y);
  }

  move(e) {
    if (!this.drawing) return;

    const coords = this.getCoords(e);

    this.ctx.lineTo(coords.x, coords.y);
    this.ctx.stroke();

    this.lastX = coords.x;
    this.lastY = coords.y;
  }

  end() {
    if (this.drawing) {
      this.drawing = false;
      this.ctx.closePath();
      this.updateData();
    }
  }

  updateData() {
    const dataInput = document.getElementById(this.canvas.id + '-data');
    if (!dataInput) return;

    const dataUrl = this.canvas.toDataURL('image/png');
    dataInput.value = dataUrl;
  }
}

function initDrawBox() {
  const canvas = document.getElementById('drawbox');
  if (canvas && !canvas.dataset.initialized) {
    canvas.dataset.initialized = 'true';

    const loadImageUrl = canvas.dataset.loadImage;
    const existingData = document.getElementById('drawbox-data');

    new DrawBox(canvas, {
      lineWidth: 3,
      showClear: true,
      loadImageUrl: loadImageUrl,
      existingData: existingData ? existingData.value : null
    });
  }

  const newPostBtn = document.getElementById('new_post_button');
  const newPostForm = document.getElementById('new_post_form');
  if (newPostBtn && newPostForm) {
    newPostBtn.addEventListener('click', (e) => {
      e.preventDefault();
      const isHidden = newPostForm.style.display === 'none';
      newPostForm.style.display = isHidden ? 'block' : 'none';
      newPostBtn.textContent = isHidden ? 'Cancel' : '+ Add Post';
    });
  }
}

document.addEventListener('DOMContentLoaded', initDrawBox);
document.addEventListener('turbo:load', initDrawBox);