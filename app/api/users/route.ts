import { NextRequest, NextResponse } from 'next/server'
import { getDB } from '@/lib/mongodb'

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const companyId = searchParams.get('companyId')
    
    const db = await getDB()
    const query = companyId ? { companyId } : {}
    const users = await db.collection('users').find(query).toArray()
    
    return NextResponse.json({ success: true, users })
  } catch (error) {
    return NextResponse.json({ success: false, error: 'Failed to fetch users' }, { status: 500 })
  }
}
