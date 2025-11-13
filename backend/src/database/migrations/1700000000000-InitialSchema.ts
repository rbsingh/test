import { MigrationInterface, QueryRunner } from 'typeorm';

export class InitialSchema1700000000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Enable UUID extension
    await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS "uuid-ossp"`);

    // Create users table
    await queryRunner.query(`
      CREATE TABLE users (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        full_name VARCHAR(255),
        phone VARCHAR(20),
        kyc_status VARCHAR(50) DEFAULT 'pending',
        virtual_balance DECIMAL(15,2) DEFAULT 1000000.00,
        refresh_token TEXT,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
      )
    `);

    // Create watchlists table
    await queryRunner.query(`
      CREATE TABLE watchlists (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_id UUID REFERENCES users(id) ON DELETE CASCADE,
        name VARCHAR(100) NOT NULL,
        symbols JSONB NOT NULL DEFAULT '[]',
        created_at TIMESTAMP DEFAULT NOW()
      )
    `);

    // Create positions table
    await queryRunner.query(`
      CREATE TABLE positions (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_id UUID REFERENCES users(id) ON DELETE CASCADE,
        symbol VARCHAR(20) NOT NULL,
        quantity INTEGER NOT NULL,
        average_cost DECIMAL(10,2) NOT NULL,
        current_price DECIMAL(10,2),
        unrealized_pnl DECIMAL(15,2),
        last_updated TIMESTAMP DEFAULT NOW(),
        UNIQUE(user_id, symbol)
      )
    `);

    // Create orders table
    await queryRunner.query(`
      CREATE TABLE orders (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        user_id UUID REFERENCES users(id) ON DELETE CASCADE,
        symbol VARCHAR(20) NOT NULL,
        order_type VARCHAR(20) NOT NULL,
        side VARCHAR(10) NOT NULL,
        quantity INTEGER NOT NULL,
        price DECIMAL(10,2),
        stop_price DECIMAL(10,2),
        status VARCHAR(20) DEFAULT 'PENDING',
        filled_quantity INTEGER DEFAULT 0,
        average_fill_price DECIMAL(10,2),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
      )
    `);

    // Create market_data table
    await queryRunner.query(`
      CREATE TABLE market_data (
        symbol VARCHAR(20) NOT NULL,
        timestamp TIMESTAMPTZ NOT NULL,
        open DECIMAL(10,2),
        high DECIMAL(10,2),
        low DECIMAL(10,2),
        close DECIMAL(10,2),
        volume BIGINT,
        PRIMARY KEY (symbol, timestamp)
      )
    `);

    // Create indexes
    await queryRunner.query(`
      CREATE INDEX idx_watchlists_user_id ON watchlists(user_id)
    `);

    await queryRunner.query(`
      CREATE INDEX idx_positions_user_id ON positions(user_id)
    `);

    await queryRunner.query(`
      CREATE INDEX idx_orders_user_id ON orders(user_id)
    `);

    await queryRunner.query(`
      CREATE INDEX idx_orders_status ON orders(status)
    `);

    await queryRunner.query(`
      CREATE INDEX idx_market_data_symbol_timestamp ON market_data(symbol, timestamp DESC)
    `);

    // Enable TimescaleDB extension and create hypertable for market_data
    await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE`);
    await queryRunner.query(`SELECT create_hypertable('market_data', 'timestamp', if_not_exists => TRUE)`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS market_data CASCADE`);
    await queryRunner.query(`DROP TABLE IF EXISTS orders CASCADE`);
    await queryRunner.query(`DROP TABLE IF EXISTS positions CASCADE`);
    await queryRunner.query(`DROP TABLE IF EXISTS watchlists CASCADE`);
    await queryRunner.query(`DROP TABLE IF EXISTS users CASCADE`);
    await queryRunner.query(`DROP EXTENSION IF EXISTS "uuid-ossp"`);
  }
}
