import { NextRequest, NextResponse } from 'next/server'
import { getDB } from '@/lib/mongodb'

export async function GET() {
  try {
    const db = await getDB()
    const teams = await db.collection('teams').find({}).toArray()
    
    return NextResponse.json({ success: true, teams })
  } catch (error) {
    console.error('Teams API error:', error)
    return NextResponse.json({ 
      success: false, 
      error: 'Failed to fetch teams',
      details: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 })
  }
}
