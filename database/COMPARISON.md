# Database Comparison: MongoDB vs PostgreSQL for KRIYA IDE

## Analysis

### Current Requirements
1. **Companies** → **Users** (Admins/Employees)
2. **Teams** with team leads
3. **Team Members** (junction table with roles)
4. **Workspaces** with files
5. **Notifications** and activity logs
6. **Real-time collaboration** tracking

---

## MongoDB - ✅ **RECOMMENDED**

### Advantages
✅ **Flexible Schema** - Perfect for workspace files with varying content
✅ **JSON Native** - Stores active_members, file content naturally
✅ **Horizontal Scaling** - Better for real-time collaboration
✅ **Fast Writes** - Ideal for frequent file updates
✅ **Embedded Documents** - Team with members in one document
✅ **No Migrations** - Easy schema evolution
✅ **Real-time** - Change streams for live updates

### MongoDB Schema
```javascript
// companies collection
{
  _id: "company-1",
  name: "Tech Inc",
  domain: "tech.com",
  createdAt: ISODate()
}

// users collection
{
  _id: "user-1",
  companyId: "company-1",
  email: "admin@tech.com",
  passwordHash: "...",
  name: "John Admin",
  avatar: "...",
  role: "OWNER", // or "EMPLOYEE"
  status: "active",
  createdAt: ISODate(),
  lastLogin: ISODate()
}

// teams collection
{
  _id: "team-1",
  companyId: "company-1",
  name: "Frontend Team",
  description: "React Development",
  teamLeadId: "user-1",
  mode: "LIVE",
  members: [
    {
      userId: "user-1",
      role: "lead",
      status: "online",
      joinedAt: ISODate(),
      lastSeen: ISODate(),
      currentFile: "/src/App.tsx"
    }
  ],
  workspace: {
    currentSession: "session-123",
    activeMembers: ["user-1", "user-2"],
    files: [
      {
        id: "file-1",
        name: "App.tsx",
        path: "/src/App.tsx",
        content: "...",
        language: "typescript",
        lastModified: ISODate(),
        modifiedBy: "user-1"
      }
    ]
  },
  createdAt: ISODate(),
  lastActivity: ISODate()
}

// notifications collection
{
  _id: "notif-1",
  userId: "user-2",
  teamId: "team-1",
  type: "team_added",
  message: "You were added to Frontend Team",
  isRead: false,
  createdAt: ISODate()
}
```

### Queries
```javascript
// Get team with members
db.teams.findOne({ _id: "team-1" })

// Add member to team
db.teams.updateOne(
  { _id: "team-1" },
  { $push: { members: { userId: "user-3", role: "developer" } } }
)

// Update file content (real-time)
db.teams.updateOne(
  { _id: "team-1", "workspace.files.id": "file-1" },
  { $set: { "workspace.files.$.content": "new content" } }
)
```

---

## PostgreSQL - ⚠️ **NOT RECOMMENDED**

### Disadvantages
❌ **Complex Joins** - Need 5+ joins for team with members and files
❌ **Rigid Schema** - Migrations needed for changes
❌ **Slower for Files** - LONGTEXT not ideal for frequent updates
❌ **JSON Support** - Limited compared to MongoDB
❌ **Scaling** - Vertical scaling only
❌ **Real-time** - Requires additional tools (Hasura, PostgREST)

### When to Use PostgreSQL
- Strong ACID requirements
- Complex transactions
- Financial data
- Strict data integrity

---

## Recommendation: **MongoDB**

### Why MongoDB Wins
1. **Real-time collaboration** - Change streams, fast updates
2. **Flexible workspace files** - No schema constraints
3. **Embedded members** - Single query for team data
4. **Horizontal scaling** - Multiple users editing simultaneously
5. **JSON native** - Perfect for IDE workspace state
6. **Faster development** - No migrations, flexible schema

### Setup
```bash
# Install MongoDB driver
npm install mongodb

# Environment variable
DATABASE_URL=mongodb://localhost:27017/kriya_ide
# Or MongoDB Atlas
DATABASE_URL=mongodb+srv://user:pass@cluster.mongodb.net/kriya_ide
```

### Migration Path
If you need PostgreSQL later:
- Keep MongoDB for workspaces/files (real-time)
- Use PostgreSQL for users/companies (structured data)
- Hybrid approach: Best of both worlds
