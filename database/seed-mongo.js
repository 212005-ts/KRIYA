// MongoDB Schema & Seed Data for KRIYA IDE
// Run: node database/seed-mongo.js

const { MongoClient } = require('mongodb')

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/kriya_ide'

const companies = [
  {
    _id: 'company-1',
    name: 'Tech Innovations Inc',
    domain: 'techinnovations.com',
    createdAt: new Date(),
    updatedAt: new Date()
  }
]

const users = [
  {
    _id: 'user-admin-1',
    companyId: 'company-1',
    email: 'admin@techinnovations.com',
    passwordHash: '$2b$10$hash',
    name: 'John Admin',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=john',
    role: 'OWNER',
    status: 'active',
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: 'user-emp-1',
    companyId: 'company-1',
    email: 'sarah@techinnovations.com',
    passwordHash: '$2b$10$hash',
    name: 'Sarah Chen',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=sarah',
    role: 'EMPLOYEE',
    status: 'active',
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: 'user-emp-2',
    companyId: 'company-1',
    email: 'mike@techinnovations.com',
    passwordHash: '$2b$10$hash',
    name: 'Mike Johnson',
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=mike',
    role: 'EMPLOYEE',
    status: 'active',
    createdAt: new Date(),
    updatedAt: new Date()
  }
]

const teams = [
  {
    _id: 'team-1',
    companyId: 'company-1',
    name: 'Frontend Team',
    description: 'React & Next.js Development',
    teamLeadId: 'user-emp-1',
    mode: 'LIVE',
    members: [
      {
        userId: 'user-emp-1',
        role: 'lead',
        status: 'online',
        joinedAt: new Date(),
        lastSeen: new Date(),
        currentFile: '/src/components/Dashboard.tsx'
      },
      {
        userId: 'user-emp-2',
        role: 'developer',
        status: 'online',
        joinedAt: new Date(),
        lastSeen: new Date(),
        currentFile: '/src/pages/api/users.ts'
      }
    ],
    workspace: {
      currentSession: 'session-1',
      activeMembers: ['user-emp-1', 'user-emp-2'],
      files: [
        {
          id: 'file-1',
          name: 'Dashboard.tsx',
          path: '/src/components/Dashboard.tsx',
          content: 'import React from "react"\n\nexport default function Dashboard() {\n  return <div>Dashboard</div>\n}',
          language: 'typescript',
          lastModified: new Date(),
          modifiedBy: 'user-emp-1',
          isActive: true
        }
      ]
    },
    createdAt: new Date(),
    lastActivity: new Date()
  }
]

const notifications = [
  {
    _id: 'notif-1',
    userId: 'user-emp-2',
    teamId: 'team-1',
    type: 'team_added',
    title: 'Added to Team',
    message: 'You have been added to Frontend Team',
    isRead: false,
    createdAt: new Date()
  }
]

async function seed() {
  const client = new MongoClient(MONGODB_URI)
  
  try {
    await client.connect()
    const db = client.db()
    
    // Drop existing collections
    await db.collection('companies').deleteMany({})
    await db.collection('users').deleteMany({})
    await db.collection('teams').deleteMany({})
    await db.collection('notifications').deleteMany({})
    
    // Insert seed data
    await db.collection('companies').insertMany(companies)
    await db.collection('users').insertMany(users)
    await db.collection('teams').insertMany(teams)
    await db.collection('notifications').insertMany(notifications)
    
    // Create indexes
    await db.collection('users').createIndex({ email: 1 }, { unique: true })
    await db.collection('users').createIndex({ companyId: 1, role: 1 })
    await db.collection('teams').createIndex({ companyId: 1 })
    await db.collection('teams').createIndex({ teamLeadId: 1 })
    await db.collection('notifications').createIndex({ userId: 1, isRead: 1 })
    
    console.log('✓ MongoDB seeded successfully')
  } catch (error) {
    console.error('Seed error:', error)
  } finally {
    await client.close()
  }
}

seed()
