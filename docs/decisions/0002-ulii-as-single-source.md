# ADR 0002: Use ULII as the single data source

- **Status:** Accepted
- **Date:** 2026-10-31

## Context

Several team members will add data in parallel. If each uses different websites, PDFs or
textbooks, the graph will contain inconsistent titles, numbering and versions of the law,
and reviewers cannot easily verify contributions.

## Decision

The **Uganda Legal Information Institute (ULII, https://ulii.org/)** is the only source for
all data in the graph. Anything not published on ULII is out of scope.

## Consequences

- Every fact is verifiable by a reviewer from one place; every node links back to ULII.
- Consistent text versions and numbering across the team.
- The **National Land Policy, 2013** is removed from scope: it is a policy document, not
  legislation, and is not published on ULII.
- Plain-language `summary` and `definition` values are still written by the team, but must be
  based only on the ULII text.
