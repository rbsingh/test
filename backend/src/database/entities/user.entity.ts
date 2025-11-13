import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { Exclude } from 'class-transformer';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true, length: 255 })
  email: string;

  @Column({ length: 255 })
  @Exclude()
  passwordHash: string;

  @Column({ nullable: true, length: 255 })
  fullName: string;

  @Column({ nullable: true, length: 20 })
  phone: string;

  @Column({ default: 'pending', length: 50 })
  kycStatus: string;

  @Column({ type: 'decimal', precision: 15, scale: 2, default: 1000000.00 })
  virtualBalance: number;

  @Column({ nullable: true })
  @Exclude()
  refreshToken: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
