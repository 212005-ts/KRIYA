# MongoDB Setup for KRIYA IDE

## Quick Start

### 1. Install MongoDB

**macOS:**
```bash
brew install mongodb-community
brew services start mongodb-community
```

**Ubuntu:**
```bash
sudo apt install mongodb
sudo systemctl start mongodb
```

**Windows:**
Download from https://www.mongodb.com/try/download/community

### 2. Seed Database

```bash
node database/seed-mongo.js
```

### 3. Environment Variable

Add to `.env.local`:
```env
MONGODB_URI=mongodb://localhost:27017/kriya_ide
```

### 4. Verify Connection

```bash
mongosh kriya_ide
> db.users.find()
> db.teams.find()
```

## MongoDB Atlas (Cloud)

1. Create free cluster at https://cloud.mongodb.com
2. Get connection string
3. Update `.env.local`:
```env
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/kriya_ide
```

## Collections

- **companies** - Organizations
- **users** - Admins & Employees
- **teams** - Teams with embedded members & workspace
- **notifications** - User notifications
- **activity_logs** - Audit trail

## Sample Queries

```javascript
// Get all employees
db.users.find({ companyId: "company-1", role: "EMPLOYEE" })

// Get team with members
db.teams.findOne({ _id: "team-1" })

// Add member to team
db.teams.updateOne(
  { _id: "team-1" },
  { $push: { members: { userId: "user-3", role: "developer", status: "offline", joinedAt: new Date(), lastSeen: new Date() } } }
)

// Update file content
db.teams.updateOne(
  { _id: "team-1", "workspace.files.id": "file-1" },
  { $set: { "workspace.files.$.content": "new content", "workspace.files.$.lastModified": new Date() } }
)

// Get unread notifications
db.notifications.find({ userId: "user-emp-2", isRead: false })
```

## Indexes

Automatically created:
- `users.email` (unique)
- `users.companyId + role`
- `teams.companyId`
- `notifications.userId + isRead`
