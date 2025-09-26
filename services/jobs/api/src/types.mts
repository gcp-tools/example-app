import { z } from 'zod/v4'

export const JobStatusEnum = z.enum([
  'Pending',
  'Accepted',
  'Processing',
  'ExtractedRules',
  'GeneratedDesign',
  'Failed',
  'Completed',
])
export type JobStatus = z.infer<typeof JobStatusEnum>

export const JobSubmissionRequestSchema = z.object({
  session_id: z.string().describe('User session identifier.'),
  lidar_scan_path: z
    .string()
    .describe('GCS path to the uploaded Lidar scan file (e.g., .las, .laz).'),
  map_data_path: z
    .string()
    .optional()
    .describe('Optional GCS path to existing map data (e.g., .geojson, .dwg).'),
  processing_parameters: z
    .record(z.any(), z.any())
    .optional()
    .describe('Dictionary of processing parameters for the job.'),
})
export type JobSubmissionRequest = z.infer<typeof JobSubmissionRequestSchema>

export const JobSubmissionResponseSchema = z.object({
  job_id: z.string().describe('Unique identifier for the submitted job.'),
  status: JobStatusEnum.default('Accepted').describe(
    'Initial status of the job.',
  ),
  message: z.string().default('Job accepted and queued for processing.'),
})
export type JobSubmissionResponse = z.infer<typeof JobSubmissionResponseSchema>

export const GetJobStatusRequestSchema = z.object({
  jobId: z.string(),
})

export const JobStatusResponseSchema = z.object({
  job_id: z.uuid(),
  status: JobStatusEnum,
  created_at: z.iso.datetime(),
  updated_at: z.iso.datetime(),
  current_step: z
    .string()
    .optional()
    .describe('Description of the current processing step.'),
  details: z
    .record(z.any(), z.any())
    .optional()
    .describe('Additional details about the job progress or errors.'),
  sanity_check: z.string().optional().default('Sanity check.'),
})
export type JobStatusResponse = z.infer<typeof JobStatusResponseSchema>

export const envVarsSchema = z.object({
  FIRESTORE_PROJECT_ID: z.string().describe('Firestore project ID.'),
  PORT: z.coerce.number().describe('Port to listen on.'),
})
export type EnvVars = z.infer<typeof envVarsSchema>

// export const buildConfigSchema = z.object({
//   buildArgs: z
//     .record(z.string(), z.string())
//     .optional()
//     .describe('Build arguments.'),
//   timeout: z.string().optional().describe('Build timeout.'),
//   machineType: z.string().optional().describe('Machine type.'),
//   buildTrigger: z.string().optional().describe('Build trigger.'),
// })
// export type BuildConfig = z.infer<typeof buildConfigSchema>

// export const testConfigSchema = z.object({
//   testTrigger: z.string().optional().describe('Test trigger.'),
// })
// export type TestConfig = z.infer<typeof testConfigSchema>

// export const helpSchema = z.object({
//   help: z.string().describe('Help message.'),
// })
// export type Help = z.infer<typeof helpSchema>
