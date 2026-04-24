# HTML5 Image Board

A modern image board application built with Ruby on Rails 7.2, featuring drawing canvas functionality where users can create and share images.

## Features

- **Board System**: Create multiple topic boards/threads
- **Drawing Canvas**: Built-in canvas with color picker and brush size selector
- **Full CRUD**: Create, read, update, and delete boards and posts
- **Modern UI**: Dark theme inspired by GitHub's design
- **Pagination**: Navigate through boards and posts easily

## Tech Stack

- **Ruby**: 3.4+
- **Rails**: 7.2.3
- **Database**: SQLite (development), PostgreSQL (production)
- **Styling**: Custom CSS with CSS variables
- **Image Processing**: MiniMagick + ImageMagick

## Requirements

- Ruby 3.4+
- ImageMagick
- SQLite development libraries

### Installing ImageMagick

**macOS** (Homebrew):
```bash
brew install imagemagick
```

**Ubuntu/Debian**:
```bash
sudo apt install imagemagick libmagickwand-dev
```

**Arch Linux**:
```bash
sudo pacman -S imagemagick
```

**Windows**:
Download from [ImageMagick website](https://imagemagick.org/script/download.php#windows)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/html5imageboard.git
cd html5imageboard
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:migrate
```

4. Start the server:
```bash
rails server
```

5. Open your browser to http://localhost:3000

## Usage

### Creating a Board
1. Click "+ New Board" on the main page
2. Enter a board name (e.g., "Artwork", "Sketches")
3. Click "Create Board"

### Creating a Post
1. Open a board
2. Click "+ Add Post"
3. Draw on the canvas using different colors and brush sizes
4. Add a title
5. Click "Create Post"

### Editing/Deleting
- Click the pencil icon (✏️) to edit
- Click the trash icon (🗑️) to delete

## Project Structure

```
html5imageboard/
├── app/
│   ├── assets/
│   │   ├── config/       # Asset manifest
│   │   ├── javascripts/  # JS (drawbox canvas)
│   │   └── stylesheets/  # CSS
│   ├── controllers/      # Rails controllers
│   ├── models/          # ActiveRecord models
│   └── views/           # Haml templates
├── config/
│   ├── environments/   # Environment configs
│   └── routes.rb        # Routing
├── db/
│   └── migrate/        # Database migrations
└── public/
    └── images/         # Static images
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests if any exist
5. Commit your changes (`git commit -m "Add amazing feature"`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Coding Standards

This project follows Rails conventions and uses:
- **RuboCop** for linting
- **Haml** for templates
- Symbol syntax (not hash rockets)

Run linting:
```bash
bundle exec rubocop
```

Run security check:
```bash
bundle exec brakeman
```

## License

GPL 3.0 - See LICENSE file for details.

## Support

- Open an issue for bugs
- Discussion for feature requests