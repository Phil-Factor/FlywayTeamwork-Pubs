# Flyway Teamwork Framework

**A collaborative framework for managing database development with Flyway, safely and efficiently, across teams and environments.**

---

## 🔧 What is Flyway Teamwork?

The **Flyway Teamwork Framework** extends core Flyway into a *complete, practical workflow* for team-based database development. It helps database developers, DBAs, and DevOps engineers collaborate effectively on complex databases, with full versioning, auditability, rollback, and branch-based workflows — all while preserving the discipline and simplicity that Flyway encourages.

At its core, Flyway Teamwork allows you to:

- Manage **branch-based development** while maintaining strict control over schema changes.
- Cleanly separate *design-time* and *deployment-time* concerns.
- Capture not only database structure, but also **intent, documentation, rationale**, and approval history.
- Support both **imperative** and **declarative** approaches as needed.
- Allow seamless handoff between developers and operations teams.

This framework helps you treat your database not as an afterthought but as a full participant in modern version-controlled, CI/CD-based software delivery pipelines.

---

## 💡 Why was Flyway Teamwork created?

Most database tools focus on generating change scripts — but **team-based development adds additional complexity**:

- Multiple developers working simultaneously.
- Feature branches that may diverge and converge.
- Reviewing and approving complex schema changes.
- Retaining institutional knowledge around *why* a change was made.
- Handling documentation changes separately from actual schema changes.
- Ensuring confidence in both *forward* and *backward* deployment paths.

The Flyway Teamwork Framework introduces patterns, conventions, and file structures that enable safe collaborative working — while staying compatible with Flyway’s model.

---

## 📦 What's included

The framework typically provides:

- **Clear separation of design artifacts** (schema model, documentation, test data, dependencies).
- **Script generation patterns** for both automatic and hand-crafted migration scripts.
- **Metadata layers** to capture narrative, ownership, review status, and deployment intent.
- **Branch management guidance** for feature branches, hotfixes, and release candidates.
- Integration points for:
  - Flyway Desktop
  - Flyway CLI
  - Source control (Git, Azure DevOps, GitHub, etc.)
  - CI/CD pipelines

---

## 🔬 Who is Flyway Teamwork for?

- Development teams managing evolving databases.
- DBAs overseeing complex schema evolution.
- DevOps teams building automated database delivery pipelines.
- Enterprises seeking auditability, predictability, and traceability in schema management.

Whether you work with SQL Server, PostgreSQL, MySQL, or other RDBMS platforms, the Flyway Teamwork approach applies.

---

## 📖 Learn More

You can read the original **Redgate article introducing Flyway Teamwork** here:\
👉 [What is the Flyway Teamwork Framework?](https://www.red-gate.com/hub/product-learning/flyway/what-is-the-flyway-teamwork-framework)

---

## 🚀 Getting Started

If you're new to Flyway or Flyway Teamwork:

1. Start with a **clean branch-based workflow**.
2. Capture schema models and design intent.
3. Generate and review scripts before merging.
4. Deploy with confidence.

This repository includes examples, templates, and guidance to help you get started.

---

> **Note:** The Flyway Teamwork Framework builds on years of practical experience from real-world teams. It’s pragmatic, flexible, and designed to evolve with your organization’s maturity.

---

**Contributions, questions, and feedback are welcome as we continue to refine and expand the framework for the database DevOps community.**

---

# Quick Start Guide

## Prerequisites

- Git installed
- Flyway Desktop and/or Flyway CLI installed
- Access to your target database platform (SQL Server, PostgreSQL, etc.)

## Steps

1. **Clone this repository:**

```bash
git clone https://github.com/your-org/flyway-teamwork-project.git
```

2. **Create your branch:**

```bash
git checkout -b feature/my-first-change
```

3. **Capture schema into design folder** using Flyway Desktop or `flyway schema` command.

4. **Generate migration script:**

- Use Flyway Desktop to generate scripts
- Or write manual migrations into `/migrations` folder

5. **Commit your changes:**

```bash
git add .
git commit -m "Added new table for orders"
```

6. **Push to repository and open pull request.**

7. **Run CI/CD pipeline** (example YAMLs provided in `/ci-templates`).

8. **Deploy safely with confidence!**

---

# Repository Structure

```bash
/
│
├── design/          # Schema model, captured design, and narrative metadata
├── migrations/      # Flyway versioned migration scripts
├── undo/            # (Optional) Undo scripts for Flyway Enterprise users
├── metadata/        # Change proposals, rationales, design decisions
├── documentation/   # Technical docs and internal references
├── tests/           # Integration and unit tests for database code
├── ci-templates/    # Example CI/CD pipeline configurations
└── README.md        # This document
```

---

# Contributing

We welcome contributions to improve and evolve the Flyway Teamwork Framework.

## Ways to contribute

- Suggest new patterns or structures.
- Share scripts or examples from your own usage.
- Propose enhancements to workflows.
- Report issues or missing documentation.

## Contribution Process

1. Fork this repository
2. Create a feature branch
3. Submit a pull request
4. All submissions will be reviewed before merge.

---

Thank you for helping build better collaborative workflows for database teams!

