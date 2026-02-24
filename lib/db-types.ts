import { ObjectId } from 'mongodb'

export interface Company {
  _id: string
  name: string
  domain?: string
  createdAt: Date
  updatedAt: Date
}

export interface User {
  _id: string
  companyId: string
  email: string
  passwordHash: string
  name: string
  avatar?: string
  role: 'OWNER' | 'EMPLOYEE'
  status: 'active' | 'inactive' | 'suspended'
  createdAt: Date
  updatedAt: Date
  lastLogin?: Date
}

export interface TeamMember {
  userId: string
  role: 'lead' | 'developer' | 'designer'
  status: 'online' | 'offline' | 'away'
  joinedAt: Date
  lastSeen: Date
  currentFile?: string
}

export interface WorkspaceFile {
  id: string
  name: string
  path: string
  content: string
  language: string
  lastModified: Date
  modifiedBy: string
  isActive: boolean
}

export interface Team {
  _id: string
  companyId: string
  name: string
  description: string
  teamLeadId?: string
  mode: 'LIVE' | 'SOLO'
  members: TeamMember[]
  workspace: {
    currentSession?: string
    activeMembers: string[]
    files: WorkspaceFile[]
  }
  createdAt: Date
  lastActivity: Date
}

export interface Notification {
  _id: string
  userId: string
  teamId?: string
  type: 'team_added' | 'team_removed' | 'role_changed' | 'team_invite'
  title: string
  message: string
  isRead: boolean
  createdAt: Date
}

export interface ActivityLog {
  _id: string
  userId: string
  teamId?: string
  action: string
  details?: any
  ipAddress?: string
  createdAt: Date
}
