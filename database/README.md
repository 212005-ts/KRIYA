# KRIYA IDE Database

## Schema Overview

### Tables

1. **companies** - Company/Organization data
2. **users** - Admins (OWNER) and Employees (EMPLOYEE)
3. **teams** - Development teams with team lead
4. **team_members** - Junction table linking users to teams with roles
5. **team_workspaces** - Team workspace configuration
6. **workspace_files** - Files in team workspaces
7. **notifications** - User notifications
8. **activity_logs** - Audit trail

## Key Relationships

```
companies
  └── users (OWNER/EMPLOYEE)
       └── teams (created by OWNER)
            ├── team_lead_id → users (one team lead)
            └── team_members → users (many employees)
                 └── role: lead/developer/designer
```

## Setup

### PostgreSQL

```bash
# Create database
createdb kriya_ide

# Run schema
psql kriya_ide < database/schema.sql

# Load seed data
psql kriya_ide < database/seed.sql
```

### MySQL

```bash
# Create database
mysql -u root -p -e "CREATE DATABASE kriya_ide;"

# Run schema
mysql -u root -p kriya_ide < database/schema.sql

# Load seed data
mysql -u root -p kriya_ide < database/seed.sql
```

## Environment Variables

Add to `.env.local`:

```env
# PostgreSQL
DATABASE_URL=postgresql://user:password@localhost:5432/kriya_ide

# MySQL
DATABASE_URL=mysql://user:password@localhost:3306/kriya_ide
```

## Key Features

### Role Hierarchy
- **OWNER** (Admin): Creates teams, manages employees, assigns team leads
- **EMPLOYEE**: Can be assigned to teams, can be promoted to team lead
- **Team Lead**: Special role within team_members table (role='lead')

### Team Member Transfer
1. Admin adds employee to team → Creates `team_members` record
2. Admin can set `role='lead'` → Employee becomes team lead
3. Team table has `team_lead_id` pointing to the lead user

### Notifications
- Automatic notifications when:
  - Employee added to team
  - Employee removed from team
  - Role changed (promoted to lead)
  - Team invite sent

## Queries

### Get all employees in a company
```sql
SELECT * FROM users 
WHERE company_id = 'company-1' AND role = 'EMPLOYEE';
```

### Get team with members
```sql
SELECT t.*, u.name as lead_name,
  (SELECT JSON_ARRAYAGG(JSON_OBJECT('id', tm.user_id, 'name', u2.name, 'role', tm.role))
   FROM team_members tm
   JOIN users u2 ON tm.user_id = u2.id
   WHERE tm.team_id = t.id) as members
FROM teams t
LEFT JOIN users u ON t.team_lead_id = u.id
WHERE t.id = 'team-1';
```

### Transfer employee to team
```sql
INSERT INTO team_members (id, team_id, user_id, role)
VALUES ('tm-new', 'team-1', 'user-emp-6', 'developer');
```

### Promote to team lead
```sql
-- Update team_members role
UPDATE team_members 
SET role = 'lead' 
WHERE team_id = 'team-1' AND user_id = 'user-emp-2';

-- Update team lead reference
UPDATE teams 
SET team_lead_id = 'user-emp-2' 
WHERE id = 'team-1';
```
