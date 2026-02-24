-- Sample data for KRIYA IDE

-- Insert sample company
INSERT INTO companies (id, name, domain) VALUES
('company-1', 'Tech Innovations Inc', 'techinnovations.com');

-- Insert admin (owner)
INSERT INTO users (id, company_id, email, password_hash, name, avatar, role) VALUES
('user-admin-1', 'company-1', 'admin@techinnovations.com', '$2b$10$hash', 'John Admin', 'https://api.dicebear.com/7.x/avataaars/svg?seed=john', 'OWNER');

-- Insert employees
INSERT INTO users (id, company_id, email, password_hash, name, avatar, role) VALUES
('user-emp-1', 'company-1', 'sarah@techinnovations.com', '$2b$10$hash', 'Sarah Chen', 'https://api.dicebear.com/7.x/avataaars/svg?seed=sarah', 'EMPLOYEE'),
('user-emp-2', 'company-1', 'mike@techinnovations.com', '$2b$10$hash', 'Mike Johnson', 'https://api.dicebear.com/7.x/avataaars/svg?seed=mike', 'EMPLOYEE'),
('user-emp-3', 'company-1', 'lisa@techinnovations.com', '$2b$10$hash', 'Lisa Park', 'https://api.dicebear.com/7.x/avataaars/svg?seed=lisa', 'EMPLOYEE'),
('user-emp-4', 'company-1', 'alex@techinnovations.com', '$2b$10$hash', 'Alex Rodriguez', 'https://api.dicebear.com/7.x/avataaars/svg?seed=alex', 'EMPLOYEE'),
('user-emp-5', 'company-1', 'emma@techinnovations.com', '$2b$10$hash', 'Emma Wilson', 'https://api.dicebear.com/7.x/avataaars/svg?seed=emma', 'EMPLOYEE');

-- Insert teams
INSERT INTO teams (id, company_id, name, description, team_lead_id, mode) VALUES
('team-1', 'company-1', 'Frontend Team', 'React & Next.js Development', 'user-emp-1', 'LIVE'),
('team-2', 'company-1', 'Backend Team', 'API & Database Development', 'user-emp-4', 'SOLO');

-- Insert team members
INSERT INTO team_members (id, team_id, user_id, role, status) VALUES
('tm-1', 'team-1', 'user-emp-1', 'lead', 'online'),
('tm-2', 'team-1', 'user-emp-2', 'developer', 'online'),
('tm-3', 'team-1', 'user-emp-3', 'designer', 'away'),
('tm-4', 'team-2', 'user-emp-4', 'lead', 'online'),
('tm-5', 'team-2', 'user-emp-5', 'developer', 'offline');

-- Insert team workspaces
INSERT INTO team_workspaces (id, team_id, current_session, active_members) VALUES
('workspace-1', 'team-1', 'session-1', '["user-emp-1", "user-emp-2"]'),
('workspace-2', 'team-2', NULL, '["user-emp-4"]');

-- Insert sample workspace files
INSERT INTO workspace_files (id, workspace_id, name, path, content, language, modified_by, is_active) VALUES
('file-1', 'workspace-1', 'Dashboard.tsx', '/src/components/Dashboard.tsx', 'import React from "react"\n\nexport default function Dashboard() {\n  return <div>Dashboard</div>\n}', 'typescript', 'user-emp-1', true),
('file-2', 'workspace-1', 'users.ts', '/src/pages/api/users.ts', 'export default function handler(req, res) {\n  res.json({ users: [] })\n}', 'typescript', 'user-emp-2', true),
('file-3', 'workspace-2', 'server.js', '/src/server.js', 'const express = require("express")\nconst app = express()\n\napp.listen(3000)', 'javascript', 'user-emp-4', true);
