import { randomUUID } from 'node:crypto'
import { Firestore } from '@google-cloud/firestore'
import bodyParser from 'body-parser'
import express, { type Request, type Response } from 'express'
import {
  GetJobStatusRequestSchema,
  type JobStatusResponse,
  JobSubmissionRequestSchema,
  envVarsSchema,
} from './types.mjs'

const envVars = envVarsSchema.parse(process.env)

const firestore = new Firestore({
  projectId: envVars.FIRESTORE_PROJECT_ID,
})
const jobsCollection = firestore.collection('jobs')

const app = express()
app.use(bodyParser.json())

// Health check endpoint
app.get('/health', (_req: Request, res: Response): void => {
  res.status(200).send('OK')
})

// Submit a new job
app.post('/jobs', async (req: Request, res: Response): Promise<void> => {
  const validationResult = JobSubmissionRequestSchema.safeParse(req.body)

  if (!validationResult.success) {
    res.status(400).json({
      message: 'Validation Failed',
      errors: validationResult.error.issues,
    })
    return
  }

  const job_id = randomUUID()
  const now = new Date()

  const newJob: JobStatusResponse = {
    job_id,
    status: 'Accepted',
    created_at: now.toISOString(),
    updated_at: now.toISOString(),
    current_step: 'Pending',
    sanity_check: 'Sanity check.',
  }

  try {
    await jobsCollection.doc(job_id).set(newJob)
    console.log(`Job ${job_id} submitted successfully.`)

    res.status(202).json({
      job_id,
      status: 'Accepted',
      message: `Job ${job_id} accepted and is pending processing.`,
    })
  } catch (error) {
    console.error(`Error submitting job ${job_id}:`, error)
    res.status(500).json({ message: 'Internal Server Error' })
  }
})

// Get job status
app.get('/jobs/:jobId', async (req: Request, res: Response): Promise<void> => {
  const validationResult = GetJobStatusRequestSchema.safeParse(req.params)

  if (!validationResult.success) {
    res.status(400).json({
      message: 'Invalid job ID format.',
      errors: validationResult.error.issues,
    })
    return
  }

  const { jobId } = validationResult.data

  try {
    const jobDoc = await jobsCollection.doc(jobId).get()

    if (jobDoc.exists) {
      res.status(200).json(jobDoc.data())
    } else {
      res.status(404).json({ message: `Job with ID ${jobId} not found.` })
    }
  } catch (error) {
    console.error(`Error retrieving job ${jobId}:`, error)
    res.status(500).json({ message: 'Internal Server Error' })
  }
})

app.listen(envVars.PORT, () => {
  console.log(`Server is running on port ${envVars.PORT}`)
})
