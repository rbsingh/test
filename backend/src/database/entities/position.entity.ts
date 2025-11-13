import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Unique,
} from 'typeorm';
import { User } from './user.entity';

@Entity('positions')
@Unique(['userId', 'symbol'])
export class Position {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  userId: string;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'userId' })
  user: User;

  @Column({ length: 20 })
  symbol: string;

  @Column({ type: 'int' })
  quantity: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  averageCost: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  currentPrice: number;

  @Column({ type: 'decimal', precision: 15, scale: 2, nullable: true })
  unrealizedPnl: number;

  @UpdateDateColumn()
  lastUpdated: Date;
}
