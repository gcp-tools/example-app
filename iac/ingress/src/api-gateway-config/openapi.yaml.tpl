swagger: "2.0"
info:
  title: LiPlan API
  version: v1
  description: API for the Lidar Planning Tool
schemes:
  - https
produces:
  - application/json

paths:
  /jobs:
    options:
      summary: "CORS support"
      operationId: "cors-jobs"
      responses:
        "204":
          description: "No Content"
          headers:
            Access-Control-Allow-Origin:
              type: "string"
            Access-Control-Allow-Methods:
              type: "string"
            Access-Control-Allow-Headers:
              type: "string"
            Access-Control-Max-Age:
              type: "integer"
    post:
      summary: Submit a new planning job
      operationId: submitJob
      x-google-backend:
        address: ${JOBS_BACKEND_URI}
        path_translation: APPEND_PATH_TO_ADDRESS
      consumes:
        - application/json
      parameters:
        - in: body
          name: body
          description: Job submission details
          required: true
          schema:
            $ref: '#/definitions/JobSubmissionRequest'
      responses:
        '202':
          description: Job accepted
          schema:
            $ref: '#/definitions/JobSubmissionResponse'
        '400':
          description: Invalid request
          schema:
            $ref: '#/definitions/ErrorResponse'

  /jobs/{jobId}:
    options:
      summary: "CORS support"
      operationId: "cors-jobs-jobid"
      parameters:
        - name: jobId
          in: path
          required: true
          type: string
          description: "Path parameter (unused for OPTIONS but required for matching)"
      responses:
        "204":
          description: "No Content"
          headers:
            Access-Control-Allow-Origin:
              type: "string"
            Access-Control-Allow-Methods:
              type: "string"
            Access-Control-Allow-Headers:
              type: "string"
            Access-Control-Max-Age:
              type: "integer"
    get:
      summary: Get job status
      operationId: getJobStatus
      x-google-backend:
        address: ${JOBS_BACKEND_URI}
        path_translation: APPEND_PATH_TO_ADDRESS
      parameters:
        - name: jobId
          in: path
          required: true
          description: ID of the job to retrieve
          type: string
      responses:
        '200':
          description: Job status
          schema:
            $ref: '#/definitions/JobStatusResponse'
        '404':
          description: Job not found
          schema:
            $ref: '#/definitions/ErrorResponse'

definitions:
  JobStatus:
    type: string
    enum:
      - Pending
      - Processing
      - Completed
      - Failed
      - Canceled

  JobSubmissionRequest:
    type: object
    required:
      - session_id
      - lidar_scan_path
    properties:
      session_id:
        type: string
      lidar_scan_path:
        type: string
      map_data_path:
        type: string
      processing_parameters:
        type: object

  JobSubmissionResponse:
    type: object
    properties:
      job_id:
        type: string
        format: uuid
      status:
        $ref: '#/definitions/JobStatus'
      message:
        type: string

  JobStatusResponse:
    type: object
    properties:
      job_id:
        type: string
      status:
        $ref: '#/definitions/JobStatus'
      created_at:
        type: string
        format: date-time
      updated_at:
        type: string
        format: date-time
      current_step:
        type: string
      details:
        type: object

  ErrorResponse:
    type: object
    properties:
      message:
        type: string
      details:
        type: object
