import { MongoClient, Db, ServerApiVersion } from 'mongodb'

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/kriya_ide'

let client: MongoClient | null = null
let db: Db | null = null

export async function connectDB(): Promise<Db> {
  if (db) return db

  client = new MongoClient(MONGODB_URI, {
    serverApi: {
      version: ServerApiVersion.v1,
      strict: true,
      deprecationErrors: true,
    }
  })
  await client.connect()
  db = client.db()
  
  console.log('✓ MongoDB connected')
  return db
}

export async function getDB(): Promise<Db> {
  if (!db) return await connectDB()
  return db
}

export async function closeDB() {
  if (client) {
    await client.close()
    client = null
    db = null
  }
}
