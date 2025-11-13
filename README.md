# Indian Equity Trading App - Paper Trading Platform

A comprehensive mobile trading application for the Indian equity market (NSE/BSE) with real-time market data and paper trading functionality. Built with Flutter (mobile) and NestJS (backend).

## 🚨 Regulatory Compliance

- **SEBI Compliance**: Paper trading with live market data using ICICI Breeze API's sandbox environment
- **No Broker License Required**: Uses broker's UAT environment for paper trading
- **Risk Disclaimers**: Proper disclaimers included in registration flow
- **Virtual Trading Only**: No real money transactions

## 📋 Features (Phase 1 - Authentication Complete)

### ✅ Completed
- [x] Backend API with NestJS + TypeScript
- [x] PostgreSQL database with TypeORM + TimescaleDB
- [x] JWT authentication (access + refresh tokens)
- [x] Password security with bcrypt (salt rounds = 12)
- [x] Flutter app with clean architecture
- [x] BLoC state management
- [x] Secure token storage (flutter_secure_storage)
- [x] User registration and login
- [x] Auto token refresh on 401 errors

### 🚧 Coming Next (Phase 2)
- [ ] ICICI Breeze API integration
- [ ] Real-time market data (WebSocket)
- [ ] Watchlist management
- [ ] Portfolio tracking
- [ ] Paper trading engine
- [ ] Order entry (Market, Limit, Stop-Loss)
- [ ] Charts with technical indicators
- [ ] Price alerts with push notifications

## 🛠 Tech Stack

### Backend
- **Framework**: NestJS with TypeScript
- **Database**: PostgreSQL 14+ with TimescaleDB extension
- **Cache**: Redis 7+
- **Authentication**: JWT (RS256), bcrypt
- **API Documentation**: RESTful API

### Mobile
- **Framework**: Flutter 3.0+
- **State Management**: BLoC pattern
- **Storage**: Hive + flutter_secure_storage
- **Charts**: FL Chart + Syncfusion
- **Networking**: Dio + WebSocket

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

### Required
- **Node.js**: v18+ ([Download](https://nodejs.org/))
- **npm**: v9+ (comes with Node.js)
- **Flutter**: v3.0+ ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Docker**: v20+ ([Download](https://www.docker.com/get-started))
- **Docker Compose**: v2+ (included with Docker Desktop)

### Optional
- **PostgreSQL**: v14+ (if not using Docker)
- **Redis**: v7+ (if not using Docker)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd trading-app
```

### 2. Start Database Services (Docker)

```bash
# Start PostgreSQL and Redis
docker-compose up -d

# Verify services are running
docker-compose ps
```

### 3. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env with your configuration (use defaults for development)

# Run migrations
npm run migration:run

# Start development server
npm run start:dev
```

Backend will be available at: `http://localhost:3000/api`

### 4. Mobile App Setup

```bash
cd mobile

# Install dependencies
flutter pub get

# Check for issues
flutter doctor

# Run on iOS Simulator
flutter run -d "iPhone 15 Pro"

# Or run on Android Emulator
flutter run -d emulator-5554
```

## 📝 Environment Configuration

### Backend (.env)

The `.env.example` file contains all necessary configuration. For development, you can use the defaults:

```env
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api

# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=trading_app

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_ACCESS_TOKEN_EXPIRY=15m
JWT_REFRESH_TOKEN_EXPIRY=30d
```

### Mobile

Update backend URL in `lib/core/config/app_config.dart` if needed:

```dart
// For iOS Simulator
static const String baseUrl = 'http://localhost:3000/api';

// For Android Emulator
// static const String baseUrl = 'http://10.0.2.2:3000/api';
```

## 🏗 Project Structure

```
trading-app/
├── backend/                    # NestJS Backend
│   ├── src/
│   │   ├── auth/              # Authentication module
│   │   ├── users/             # Users module
│   │   ├── market-data/       # Market data module (coming)
│   │   ├── orders/            # Orders module (coming)
│   │   ├── portfolio/         # Portfolio module (coming)
│   │   ├── watchlists/        # Watchlists module (coming)
│   │   ├── notifications/     # Notifications module (coming)
│   │   ├── database/
│   │   │   ├── entities/      # TypeORM entities
│   │   │   └── migrations/    # Database migrations
│   │   └── config/            # Configuration files
│   └── package.json
│
├── mobile/                     # Flutter Mobile App
│   ├── lib/
│   │   ├── core/
│   │   │   ├── config/        # App configuration
│   │   │   ├── di/            # Dependency injection
│   │   │   └── network/       # HTTP client & interceptors
│   │   └── features/
│   │       └── auth/          # Authentication feature
│   │           ├── data/      # Data layer (models, datasources, repos)
│   │           ├── domain/    # Domain layer (entities, usecases)
│   │           └── presentation/ # UI layer (BLoC, screens, widgets)
│   └── pubspec.yaml
│
├── docker-compose.yml          # Docker services configuration
└── README.md
```

## 🔐 Authentication Flow

### Registration
1. User enters email, password, full name, phone (optional)
2. Backend validates and hashes password (bcrypt, 12 rounds)
3. User record created with virtual balance (₹10,00,000)
4. JWT tokens generated and returned
5. Tokens stored in secure storage (iOS Keychain/Android Keystore)

### Login
1. User enters email and password
2. Backend validates credentials
3. JWT tokens generated and returned
4. Tokens stored securely

### Token Refresh
- Access token expires in 15 minutes
- On 401 error, app automatically refreshes using refresh token
- New tokens stored and request retried
- If refresh fails, user logged out

## 📡 API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| POST | `/api/auth/refresh` | Refresh access token | No |
| POST | `/api/auth/logout` | Logout user | Yes |

### Request/Response Examples

**Register**:
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test@1234",
    "fullName": "Test User",
    "phone": "9876543210"
  }'
```

Response:
```json
{
  "statusCode": 201,
  "message": "User registered successfully",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

## 🧪 Testing

### Backend

```bash
cd backend

# Unit tests
npm test

# E2E tests
npm run test:e2e

# Test coverage
npm run test:cov
```

### Mobile

```bash
cd mobile

# Run tests
flutter test

# Test with coverage
flutter test --coverage
```

## 🔧 Troubleshooting

### Backend won't start
- Check PostgreSQL is running: `docker-compose ps`
- Verify .env configuration
- Check logs: `docker-compose logs postgres`

### Flutter build errors
- Run `flutter clean && flutter pub get`
- Check Flutter version: `flutter --version`
- Ensure all dependencies are compatible

### Connection refused errors
- iOS Simulator: Use `http://localhost:3000`
- Android Emulator: Use `http://10.0.2.2:3000`
- Physical device: Use your computer's IP address

### Database migration errors
- Reset database: `docker-compose down -v && docker-compose up -d`
- Rerun migrations: `npm run migration:run`

## 📚 Next Steps

1. **Integrate ICICI Breeze API**
   - Sign up for API credentials
   - Implement WebSocket client
   - Add real-time quote streaming

2. **Build Watchlist Feature**
   - Stock search
   - Add/remove symbols
   - Real-time price updates

3. **Implement Paper Trading**
   - Order entry forms
   - Order matching engine
   - Position management

4. **Add Charts**
   - TradingView integration
   - Technical indicators
   - Multiple timeframes

## ⚠️ Disclaimer

**This is a paper trading application for educational purposes only.**

- No real money is involved
- Virtual trading does not guarantee real trading success
- Past performance does not indicate future results
- Market data may be delayed
- Not financial advice

---

**Happy Paper Trading! 📈**