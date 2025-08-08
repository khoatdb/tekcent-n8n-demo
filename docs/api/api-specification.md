# API Specification

This document defines the REST API for the XXX.AI platform. The API is organized by the epic in which the features are developed.

## 1. Authentication

The API uses JSON Web Tokens (JWT) for authentication. Clients must first authenticate via the `/auth/login` endpoint to receive a token. This token must be included in the `Authorization` header for all subsequent requests.

**Header Format:** `Authorization: Bearer <jwt_token>`

## 2. Error Handling

API errors are returned in a standardized JSON format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "A human-readable error message."
  }
}
```

**Common HTTP Status Codes:**
- `200 OK`: Request succeeded.
- `201 Created`: Resource was successfully created.
- `400 Bad Request`: The request was malformed (e.g., invalid JSON).
- `401 Unauthorized`: Authentication failed or token is missing/invalid.
- `403 Forbidden`: The authenticated user does not have permission to perform the action.
- `404 Not Found`: The requested resource does not exist.
- `500 Internal Server Error`: An unexpected server-side error occurred.

## 3. Endpoint Organization by Epic

### EPIC-1: Core Platform & MVP

#### Authentication (`/auth`)

- **`POST /auth/register`** (US-2)
  - **Description**: Registers a new customer.
  - **Request Body**:
    ```json
    { "email": "user@example.com", "password": "Str0ngP@ssw0rd!" }
    ```
  - **Response (201)**: `{ "message": "Registration successful. Please check your email for verification." }`

- **`POST /auth/login`** (US-3)
  - **Description**: Authenticates a user and returns a JWT.
  - **Request Body**:
    ```json
    { "email": "user@example.com", "password": "Str0ngP@ssw0rd!" }
    ```
  - **Response (200)**:
    ```json
    { "accessToken": "ey..." }
    ```

#### Documents (`/documents`)

- **`POST /documents`** (US-4)
  - **Description**: Uploads a document for the authenticated user.
  - **Request**: `multipart/form-data` with file and metadata.
  - **Response (201)**: `{ "documentId": "doc_123", "fileName": "annual-report.pdf", "status": "uploaded" }`

- **`GET /documents`** (US-6)
  - **Description**: Searches and retrieves a list of the user's documents.
  - **Query Params**: `?q=search_term`
  - **Response (200)**: `[ { "documentId": "...", "fileName": "..." } ]`

#### Workflows (`/workflows`)

- **`POST /workflows/company-formation`** (US-5)
  - **Description**: Initiates the company formation workflow.
  - **Request Body**: JSON object with all required company details.
  - **Response (202 Accepted)**: `{ "workflowId": "wf_abc", "status": "pending_approval" }`

### EPIC-2: Approvals & Notifications

#### Admin (`/admin`)

- **`GET /admin/approvals`** (US-7)
  - **Description**: Retrieves a list of pending approvals. (Admin only)

- **`POST /admin/approvals/{id}/decide`** (US-7)
  - **Description**: Approves or rejects a request. (Admin only)
  - **Request Body**: `{ "decision": "approved" | "rejected", "reason": "..." }`

#### E-Approvals (`/documents/{id}/approve`)

- **`POST /documents/{id}/approve`** (US-10)
  - **Description**: Applies a digital signature to a document.
  - **Request Body**: `{ "signatureData": "..." }`

### EPIC-3: AI & Advanced Features

#### Chatbot (`/chatbot`)

- **`POST /chatbot/query`** (US-11)
  - **Description**: Sends a query to the AI chatbot.
  - **Request Body**: `{ "query": "What was my revenue last quarter?" }`
  - **Response (200)**: `{ "answer": "Your revenue for Q4 2023 was $50,000." }`

#### Data (`/data`)

- **`POST /data/query`** (US-14)
  - **Description**: Performs an advanced, structured query on user data.
  - **Request Body**: `{ "query": { "type": "...", "params": { ... } } }`