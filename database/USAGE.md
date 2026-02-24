# Using MongoDB in KRIYA IDE

## Quick Start

### 1. Start MongoDB
```bash
mongod --dbpath ~/mongodb/data --fork --logpath ~/mongodb/mongod.log
```

### 2. Start App
```bash
npm run dev
```

### 3. Test API Endpoints

**Get all teams:**
```bash
curl http://localhost:3000/api/teams
```

**Get all users:**
```bash
curl http://localhost:3000/api/users
```

**Get users by company:**
```bash
curl http://localhost:3000/api/users?companyId=company-1
```

## Usage in Code

### Import MongoDB connection
```typescript
import { getDB } from '@/lib/mongodb'
```

### Query data
```typescript
const db = await getDB()

// Get all teams
const teams = await db.collection('teams').find({}).toArray()

// Get team by ID
const team = await db.collection('teams').findOne({ _id: 'team-1' })

// Get users by company
const users = await db.collection('users').find({ companyId: 'company-1' }).toArray()

// Add member to team
await db.collection('teams').updateOne(
  { _id: 'team-1' },
  { $push: { members: { userId: 'user-3', role: 'developer', status: 'offline' } } }
)

// Update file content
await db.collection('teams').updateOne(
  { _id: 'team-1', 'workspace.files.id': 'file-1' },
  { $set: { 'workspace.files.$.content': 'new content' } }
)
```

## Example: Create Team API

```typescript
// app/api/teams/create/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { getDB } from '@/lib/mongodb'

export async function POST(request: NextRequest) {
  const { name, description, companyId } = await request.json()
  
  const db = await getDB()
  const team = {
    _id: `team-${Date.now()}`,
    companyId,
    name,
    description,
    members: [],
    workspace: { files: [], activeMembers: [] },
    createdAt: new Date()
  }
  
  await db.collection('teams').insertOne(team)
  return NextResponse.json({ success: true, team })
}
```

## Collections

- **companies** - Organizations
- **users** - Admins & Employees
- **teams** - Teams with members & workspace
- **notifications** - User notifications

## MongoDB Shell Commands

```bash
# Connect to database
mongosh kriya_ide

# View all users
db.users.find().pretty()

# View all teams
db.teams.find().pretty()

# Add new user
db.users.insertOne({
  _id: 'user-new',
  companyId: 'company-1',
  email: 'new@company.com',
  name: 'New User',
  role: 'EMPLOYEE',
  status: 'active',
  createdAt: new Date()
})
```

## Stop MongoDB
```bash
mongod --shutdown --dbpath ~/mongodb/data
```
