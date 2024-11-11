# 🌳 Offering Tree

A Rails API code challenge implementation for calculating yoga teacher payments based on class attendance.

## 🎯 Purpose

This is a technical challenge implementation that helps yoga studios calculate teacher payments based on sophisticated rate structures, including:
- Base rates per client attending the class
- Bonus rates based on attendance thresholds
- Flexible minimum/maximum client count rules

## 🏗 Architecture

Built using [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) principles:
- **Entities**: Core business objects (`app/core/entities`)
- **Use Cases**: Business logic orchestration (`app/core/use_cases`)
- **Repositories**: Data access abstraction (`app/core/repositories`)
- **Serializers**: Data presentation layer (`app/core/serializers`)
- **Controllers**: HTTP interface (`app/controllers`)

## 📁 Project Structure

The project follows a Clean Architecture approach while maintaining Rails conventions. Here are the key directories:

### Core Domain (`app/core/`)
```
app/core/
├── entities/          # Business objects (PayRate, PayRateBonus)
├── repositories/      # Data access layer
│   └── errors/        # Repository-specific errors
├── serializers/       # Data presentation formatting
└── use_cases/         # Business logic operations
    └── errors/        # Use case-specific errors
```

### API Interface (`app/`)
```
app/
├── controllers/       # HTTP endpoints (API-only)
│   └── v1/            # API version 1
└── models/            # ActiveRecord models
```

### Tests (`spec/`)
```
spec/
├── core/              # Tests for domain logic
│   ├── entities/      # Entities unit tests
│   ├── repositories/  # Repositories unit tests
│   ├── serializers/   # Serializers unit tests
│   └── use_cases/     # Use cases unit tests
├── factories/         # Test data factories
├── requests/          # API endpoint integration tests
└── support/           # Test helper modules
```

### Configuration (`config/`)
```
config/
├── environments/     # Environment-specific settings
└── initializers/     # Rails initialization code
```

> Note: Standard Rails directories that are not actively used (such as `app/views/`, `app/mailers/`, `app/channels/`, etc.) are omitted for clarity.

## 🚀 Getting Started

### System Requirements

#### macOS
1. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install Required Packages:
   ```bash
   brew install rbenv ruby-build sqlite3
   ```

3. Set up Ruby:
   ```bash
   rbenv install 3.2.2
   rbenv global 3.2.2
   ```

#### Linux (Ubuntu/Debian)
1. Install Required Packages:
   ```bash
   sudo apt-get update
   sudo apt-get install -y git curl libssl-dev libreadline-dev zlib1g-dev sqlite3 libsqlite3-dev
   ```

2. Install rbenv:
   ```bash
   curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
   echo 'eval "$(rbenv init -)"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Set up Ruby:
   ```bash
   rbenv install 3.2.2
   rbenv global 3.2.2
   ```

#### Windows
1. Install WSL2:
   - Open PowerShell as Administrator and run:
     ```powershell
     wsl --install
     ```
   - Restart your computer
   - Follow the Linux (Ubuntu) instructions above in your WSL2 terminal

### Project Setup

1. Clone the Repository:
   ```bash
   git clone <repository-url>
   cd offering-tree
   ```

2. Install Dependencies:
   ```bash
   gem install bundler
   bundle install
   ```

3. Setup Database:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

   > **Note**: Make sure to run migrations in the appropriate environment: `RAILS_ENV=test bin/rails db:migrate` (before running tests) or `RAILS_ENV=development bin/rails db:migrate` (before running local server).


### Running Tests

```bash
# Run all tests with coverage
bundle exec rspec

# Run specific test file with coverage
bundle exec rspec spec/path/to/file_spec.rb

# Run tests with specific tag
bundle exec rspec --tag focus
```

### Test Coverage

The project uses SimpleCov for test coverage reporting. Coverage report is automatically generated every time you run the tests.

To view the coverage report:
```bash
open coverage/index.html            # macOS
xdg-open coverage/index.html        # Linux
explorer.exe coverage/index.html    # Windows (WSL2)
```

### Running Local Server

```bash
# Start server
bin/rails server

# Server will be available at:
http://localhost:3000
```

## 🔌 API Endpoints

### Pay Rates
- `POST /v1/pay_rates` - Create a new pay rate
- `PATCH /v1/pay_rates/:id` - Update an existing pay rate
- `GET /v1/pay_rates/:id/payment` - Calculate payment for a given client count

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
