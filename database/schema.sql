-- KRIYA IDE Database Schema
-- PostgreSQL/MySQL compatible

-- Companies table
CREATE TABLE companies (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  domain VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table (Admins + Employees)
CREATE TABLE users (
  id VARCHAR(50) PRIMARY KEY,
  company_id VARCHAR(50) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  avatar VARCHAR(500),
  role ENUM('OWNER', 'EMPLOYEE') NOT NULL,
  status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
  INDEX idx_company_role (company_id, role),
  INDEX idx_email (email)
);

-- Teams table
CREATE TABLE teams (
  id VARCHAR(50) PRIMARY KEY,
  company_id VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  team_lead_id VARCHAR(50),
  mode ENUM('LIVE', 'SOLO') DEFAULT 'SOLO',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
  FOREIGN KEY (team_lead_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_company (company_id),
  INDEX idx_team_lead (team_lead_id)
);

-- Team members (junction table with role)
CREATE TABLE team_members (
  id VARCHAR(50) PRIMARY KEY,
  team_id VARCHAR(50) NOT NULL,
  user_id VARCHAR(50) NOT NULL,
  role ENUM('lead', 'developer', 'designer') DEFAULT 'developer',
  status ENUM('online', 'offline', 'away') DEFAULT 'offline',
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  current_file VARCHAR(500),
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_team_user (team_id, user_id),
  INDEX idx_team (team_id),
  INDEX idx_user (user_id),
  INDEX idx_status (status)
);

-- Team workspaces
CREATE TABLE team_workspaces (
  id VARCHAR(50) PRIMARY KEY,
  team_id VARCHAR(50) UNIQUE NOT NULL,
  current_session VARCHAR(100),
  active_members JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE
);

-- Workspace files
CREATE TABLE workspace_files (
  id VARCHAR(50) PRIMARY KEY,
  workspace_id VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  path VARCHAR(1000) NOT NULL,
  content LONGTEXT,
  language VARCHAR(50),
  last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified_by VARCHAR(50),
  is_active BOOLEAN DEFAULT false,
  FOREIGN KEY (workspace_id) REFERENCES team_workspaces(id) ON DELETE CASCADE,
  FOREIGN KEY (modified_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_workspace (workspace_id),
  INDEX idx_modified_by (modified_by)
);

-- Notifications
CREATE TABLE notifications (
  id VARCHAR(50) PRIMARY KEY,
  user_id VARCHAR(50) NOT NULL,
  team_id VARCHAR(50),
  type ENUM('team_added', 'team_removed', 'role_changed', 'team_invite') NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
  INDEX idx_user_read (user_id, is_read),
  INDEX idx_created (created_at)
);

-- Activity logs
CREATE TABLE activity_logs (
  id VARCHAR(50) PRIMARY KEY,
  user_id VARCHAR(50) NOT NULL,
  team_id VARCHAR(50),
  action VARCHAR(100) NOT NULL,
  details JSON,
  ip_address VARCHAR(45),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_team (team_id),
  INDEX idx_created (created_at)
);

-- Performance indexes
CREATE INDEX idx_users_company_status ON users(company_id, status);
CREATE INDEX idx_teams_company_activity ON teams(company_id, last_activity);
CREATE INDEX idx_team_members_team_role ON team_members(team_id, role);
