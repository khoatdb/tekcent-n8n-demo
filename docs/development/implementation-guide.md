# Implementation Guide

This guide provides a structured approach for the development team to implement the XXX.AI platform, organized by epics and stories.

*Related Document: [Project Roadmap](/docs/project/roadmap.md)*

## 1. Epic Implementation Order

The project will be implemented in the following epic order:

1.  **EPIC-1: Develop Core Platform and Company Formation Workflow**
    - **Rationale**: This establishes the Minimum Viable Product (MVP). It builds the foundational infrastructure, user-facing portal, and the primary value-delivering workflow (company formation).
2.  **EPIC-2: Implement Company Approval, Scanning, and Notifications**
    - **Rationale**: This epic builds on the MVP by adding critical operational workflows for XXX.AI staff (approvals, scanning) and enhances customer engagement through notifications and secure e-signatures.
3.  **EPIC-3: Integrate AI Agents and Advanced Features**
    - **Rationale**: With the core platform stable, this epic introduces the key AI differentiators that fulfill the company's vision, such as the chatbot and proactive compliance agents.

## 2. Story Completion Order & Technical Enablers

Stories should be implemented in the order specified below to respect dependencies.

### EPIC-1 (Weeks 1-4)

1.  `TS-1`: Set up marketing website infrastructure.
2.  `US-1`: Launch marketing website.
3.  `TS-2`: Implement customer portal authentication.
4.  `US-2`: Implement user registration.
5.  `US-3`: Implement user login (depends on US-2).
6.  `TS-3`: Configure SharePoint for document storage.
7.  `US-4`: Implement document upload (depends on US-3).
8.  `TS-4`: Implement company formation workflow in N8N.
9.  `US-5`: Connect portal to company formation workflow (depends on US-3).
10. `US-6`: Implement basic document search (depends on US-4).

### EPIC-2 (Weeks 5-6)

1.  `TS-5`: Implement company approval workflow in N8N (depends on TS-4).
2.  `US-7`: Build admin approval interface (depends on US-5).
3.  `TS-6`: Integrate SendGrid for notifications.
4.  `US-8`: Implement notification triggers for key events.
5.  `TS-8`: Implement E-approval with digital signatures (High Risk).
6.  `US-10`: Build document e-approval interface.
7.  `TS-7`: Implement document scanning and OCR (depends on TS-3).
8.  `US-9`: Build staff interface for scanned documents (depends on US-4).

### EPIC-3 (Weeks 7-8)

1.  `TS-12`: Implement advanced querying engine (e.g., Elasticsearch).
2.  `US-14`: Build advanced query interface.
3.  `TS-9`: Integrate with a chatbot platform.
4.  `US-11`: Implement chatbot in the customer portal.
5.  `TS-11`: Implement smart form filling AI.
6.  `US-13`: Integrate smart form filling into relevant workflows.
7.  `TS-10`: Implement AI agents for compliance monitoring (High Risk).
8.  `US-12`: Connect AI agents to notification system and user dashboard.
9.  `US-15`: Implement bookkeeping and accounting services.

## 3. Technical Prerequisites

Before starting development, ensure the following are set up:

-   [ ] Provisioned AWS account with access keys.
-   [ ] N8N instance deployed and accessible.
-   [ ] Microsoft 365 tenant with SharePoint admin access.
-   [ ] API keys and sandbox accounts for:
    -   [ ] Airwallex
    -   [ ] SendGrid
-   [ ] Git repository initialized with a protected `main` branch and a `develop` branch.

## 4. Definition of Done (DoD)

A story is considered 'Done' when it meets all the following criteria:

-   All acceptance criteria from the user story are met.
-   Code is peer-reviewed and merged into the `develop` branch.
-   Unit tests are written and passing with >90% coverage.
-   Relevant integration tests are written and passing.
-   End-to-end automated tests (BDD scenarios) are implemented and passing.
-   Functionality is deployed and verified on the staging environment.
-   No new high or critical vulnerabilities are introduced (checked via static analysis).
-   Any necessary documentation (API spec, architecture diagrams) has been updated.