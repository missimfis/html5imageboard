# HTML5 Image Board

A drawing-first image board built with Ruby on Rails 8.1, Tailwind CSS 4 and daisyUI 5. Create boards, sketch directly in the browser with a pen, eraser and ready-made stamps, then share the result.

## Features

- **Board System**: Create topic boards and browse them in a responsive card grid
- **Drawing Canvas**: Pen, eraser, colors, brush sizes, undo, clear and eight ready-made stamps
- **Theme Toggle**: Custom dark and light daisyUI themes with the choice saved in `localStorage`
- **Full CRUD**: Create, read, update, and delete boards and posts
- **Ownership Checks**: Edits and deletes are limited to the browser session that created the content
- **Moderation**: Optional password-protected mode for editing or removing any content
- **Pagination**: Pagy-powered navigation through boards and posts
- **Accessible UI**: Skip link, labelled controls, keyboard undo (`Ctrl`/`⌘` + `Z`), arrow-key toolbar navigation and semantic Haml markup
- **SEO**: Canonical URLs, Open Graph/Twitter metadata, sitemap and per-page descriptions

## Tech Stack

- **Ruby**: 4.0.1 (see `.ruby-version`)
- **Rails**: 8.1.4
- **Database**: SQLite (development/test), SQLite 3 (production)
- **Asset Pipeline**: Propshaft + Importmap
- **CSS**: Tailwind CSS 4 via `tailwindcss-rails`, daisyUI 5 from npm
- **Frontend**: Turbo + Stimulus, custom drawbox controller
- **Caching**: Solid Cache (durable SQLite-backed store in production)
- **Templates**: Haml
- **Pagination**: Pagy
- **Code Quality**: RuboCop, Brakeman
- **Tests**: Minitest with fixtures

## Requirements

- Ruby 4.0.1+
- Node.js 22+ (installs daisyUI for the Tailwind build)
- SQLite development libraries

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/html5imageboard.git
cd html5imageboard
```

2. Install dependencies and prepare the database:
```bash
bin/setup
```

`bin/setup` installs gems and npm packages, prepares the database and starts `bin/dev`. To set up without starting the server, run `bin/setup --skip-server`.

Alternatively, run the steps manually:

```bash
bundle install
npm install
bin/rails db:prepare
bin/dev
```

3. Open your browser to http://localhost:3000

`bin/dev` runs the Rails server together with the Tailwind watcher. If you only need a one-off CSS build, run `bin/rails tailwindcss:build`.

### Credentials

Encrypted credentials live in `config/credentials.yml.enc` (the decryption key `config/master.key` is gitignored). Point `RAILS_MASTER_KEY` at the key, or run `bin/rails credentials:edit` locally to inspect the contents.

### Production

- Set `APP_HOSTS` to the comma-separated list of allowed hostnames (the Host header allowlist defaults to `localhost,127.0.0.1`).
- Requests are forced over HTTPS (`force_ssl` / `assume_ssl`); terminate TLS at a reverse proxy.
- The SQLite database path defaults to `db/production.sqlite3`; override with `SQLITE_DATABASE`.
- Run `npm install` before `bin/rails assets:precompile` so the daisyUI sources are available.

## Usage

### Creating a Board
1. Click **New board** in the page header, or the dashed **New board** tile at the end of the grid
2. Enter a board name (e.g., "Artwork", "Sketches")
3. Click **Create board**

### Creating a Drawing
1. Open a board and click **Add drawing**
2. Draw with the pen or eraser, or pick one of the stamps (star, heart, sparkles, bolt, smiley, sun, cloud, music)
3. Choose a color and brush size
4. Use **Undo** (`Ctrl`/`⌘` + `Z`) or **Clear** to correct mistakes
5. Add a title and description, then click **Create post**

With the keyboard, use `Tab` to move through the form and toolbar, and the arrow keys (`Home`/`End` included) to move between drawing tools.

### Editing/Deleting
- Click the pencil icon to edit a board or post
- Click the trash icon to delete, then confirm the Turbo dialog
- Edit and delete controls are only shown for content created by the current browser session

### Moderation
Set `MODERATOR_PASSWORD` (or the `moderator_password` credential) to enable the moderation link in the footer. A moderator can edit or delete any board or post; the session remains active until you choose **Exit moderation**.

Boards and posts created before ownership tracking was added have no owner token. Only a moderator can edit or delete that older content.

### Limits
- Request bodies are capped at 16 MiB by `RequestBodyLimit` before Rails parses them.
- Drawings are capped at 10 MiB decoded; oversized Base64 payloads are rejected before decoding.
- For defense in depth, configure the reverse proxy to enforce a matching request-body limit.

## Project Structure

```
html5imageboard/
├── app/
│   ├── assets/
│   │   ├── builds/        # Generated tailwind.css (gitignored)
│   │   └── tailwind/      # Tailwind entrypoint, themes and component styles
│   ├── controllers/       # Rails controllers
│   ├── helpers/           # View helpers (icons, metadata, avatar tones)
│   ├── javascript/
│   │   ├── controllers/   # Stimulus: drawbox, toggle, theme, flash
│   │   └── application.js # Importmap entrypoint
│   ├── models/            # ActiveRecord models
│   └── views/             # Haml templates
├── config/
│   ├── environments/      # Environment configs
│   └── routes.rb          # Routing
├── db/
│   └── migrate/           # Database migrations
├── test/
│   ├── controllers/       # Controller tests
│   ├── fixtures/          # Test fixtures
│   └── models/            # Model tests
├── package.json           # daisyUI dependency
└── Procfile.dev           # Rails + Tailwind watcher for bin/dev
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`bin/rails test`)
5. Commit your changes (`git commit -m "Add amazing feature"`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Coding Standards

This project follows Rails conventions and uses:
- **RuboCop** (with `rubocop-rails`) for linting
- **Haml** for templates
- Symbol bracket syntax (no hash rockets)
- Tailwind utilities in views, with shared components in `app/assets/tailwind/application.css`

Run linting:
```bash
bundle exec rubocop
```

Run the test suite:
```bash
bin/rails test
```

Run security checks:
```bash
bundle exec brakeman
bin/importmap audit
```

## License

GPL 3.0 - See LICENSE file for details.

## Support

- Open an issue for bugs
- Discussion for feature requests
