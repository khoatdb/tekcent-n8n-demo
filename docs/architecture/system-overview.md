# System Architecture: XXX.AI

This document provides a comprehensive overview of the XXX.AI system architecture, including its components, technology stack, and integration points.

## 1. System Context Diagram

The following C4 diagram illustrates the high-level system context, showing users and external systems interacting with the XXX.AI platform.

```mermaid
C4Context
  title System Context for XXX.AI Platform

  Person(customer, "SME Customer", "Registers companies, manages documents, and uses AI services via the portal.")
  Person(staff, "XXX.AI Staff", "Manages workflows, scans documents, and assists customers.")

  System_Boundary(c1, "XXX.AI Platform") {
    System(portal, "Customer Portal", "Web interface for customers.")
    System(n8n, "N8N Workflow Engine", "Core engine for automating business processes.")
    System(ai_platform, "AI Platform", "Handles data indexing, chatbot, and AI agents.")
  }

  System_Ext(sharepoint, "SharePoint", "Enterprise-grade document storage and management.")
  System_Ext(airwallex, "Airwallex", "Handles payments and subscription management.")
  System_Ext(sendgrid, "SendGrid", "Manages email, SMS, and WhatsApp notifications.")
  System_Ext(govtech, "GovTech APIs", "For regulatory and legal filings.")
  System_Ext(kyc, "EKYC Platforms", "For digital customer identity verification.")
  System_Ext(banks, "Bank APIs", "For bank account reconciliation.")

  Rel(customer, portal, "Uses")
  Rel(staff, portal, "Administers")
  Rel(staff, n8n, "Manages Workflows")

  Rel(portal, n8n, "Triggers Workflows")
  Rel(portal, ai_platform, "Queries via Chatbot")

  Rel(n8n, sharepoint, "Stores/Retrieves Documents")
  Rel(n8n, airwallex, "Manages Subscriptions")
  Rel(n8n, sendgrid, "Sends Notifications")
  Rel(n8n, govtech, "Submits Filings")
  Rel(n8n, kyc, "Performs Checks")
  Rel(n8n, banks, "Reconciles Accounts")

  Rel(ai_platform, sharepoint, "Indexes Documents")
```

## 2. Component Interactions and Dependencies

- **Customer Portal**: The primary user-facing application. It handles user authentication (US-2, US-3), presents data, and provides interfaces to trigger backend processes. It communicates with the N8N engine via REST APIs.
- **N8N Workflow Engine**: The heart of the system's automation. It executes complex workflows for company formation (US-5), approvals (US-7), notifications (US-8), and other services. It integrates with all external systems.
- **AI Platform**: A collection of services responsible for advanced features. It indexes all documents from SharePoint for self-service queries (US-14), powers the customer-facing chatbot (US-11), and runs specialized AI agents for compliance monitoring (US-12).
- **SharePoint**: Acts as the primary, secure document store. Each customer is provisioned a dedicated subsite to ensure strict data isolation. Documents are tagged and categorized, partly through OCR (US-9) and AI.

## 3. Technology Stack

- **Frontend**: Static Marketing Site (HTML/CSS/JS), Customer Portal (React or similar modern framework).
- **Backend/Automation**: N8N (Workflow Engine).
- **Document Management**: Microsoft SharePoint.
- **AI/ML**: Custom/Pre-trained LLMs (e.g., GPT), OCR libraries (e.g., Tesseract), Chatbot frameworks (e.g., Rasa, Dialogflow).
- **Database/Search**: Elasticsearch for advanced data querying (TS-12).
- **Hosting/Infrastructure**: AWS (S3 for static site).
- **Authentication**: JWT-based authentication (TS-2).
- **Integrations**:
  - **Payments**: Airwallex
  - **Notifications**: SendGrid
  - **Digital Signatures**: DocuSign or similar (for US-10)
  - **APIs**: GovTech, EKYC Platforms, Bank APIs.

## 4. Architectural Decisions (ADRs)

| ID | Decision | Rationale | Alternatives Considered |
|----|----------|-----------|-------------------------|
| ADR-01 | Use SharePoint for document management. | Provides robust security, versioning, and enterprise-grade features. Ensures data isolation per customer via subsites. | AWS S3, Google Cloud Storage |
| ADR-02 | Use N8N as the core workflow engine. | Highly flexible, extensible, and self-hostable, providing control over data and integrations. | Zapier, IFTTT, custom code |
| ADR-03 | Integrate with Airwallex for payments. | Offers a comprehensive solution for payments and tiered subscription management suitable for the target market. | Stripe, PayPal |