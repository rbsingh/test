import {
  Entity,
  Column,
  PrimaryColumn,
} from 'typeorm';

@Entity('market_data')
export class MarketData {
  @PrimaryColumn({ length: 20 })
  symbol: string;

  @PrimaryColumn({ type: 'timestamptz' })
  timestamp: Date;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  open: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  high: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  low: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  close: number;

  @Column({ type: 'bigint' })
  volume: number;
}
