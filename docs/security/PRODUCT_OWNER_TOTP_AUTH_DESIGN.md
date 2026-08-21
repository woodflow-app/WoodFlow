# Product Owner TOTP Authorization — Design & Threat Model

**Status:** DESIGN FOR INDEPENDENT REVIEW — NOT APPROVED FOR MERGE  
**Approver:** Piotr Dobrowolski — Product Owner  
**Plan/Build authorization:** GRANTED for this design scope only  
**Merge authorization:** NOT GRANTED  

## 1. Purpose

Design a Product Owner authorization mechanism using Google Authenticator-compatible TOTP without exposing the TOTP secret or six-digit codes to ChatGPT, Claude, Claude Code, GitHub comments, or repository files.

This document is the design and threat-model phase only. It does not authorize production implementation or merge.

## 2. Security goals

The mechanism must ensure that:

1. The TOTP seed remains under Piotr Dobrowolski's control and is never stored in chat history, repository content, PR comments, logs, screenshots intended for agents, or AI prompts.
2. Six-digit TOTP codes are entered only into a dedicated verifier surface and are never copied into ChatGPT, Claude, Claude Code, or GitHub.
3. A successful verification creates a durable authorization record that contains no reusable secret.
4. Every authorization is bound to one explicit decision and immutable target data.
5. `MERGE APPROVED` is bound to an exact PR number and exact independently verified HEAD SHA.
6. A new commit after merge authorization makes the previous authorization unusable for the new HEAD.
7. Replaying an old authorization proof for another PR, SHA, decision type, or project must fail.
8. AI agents may verify the resulting proof/status but must not possess enough information to generate a valid Product Owner authorization themselves.

## 3. Non-goals

This first design does not attempt to:

- replace Google Authenticator;
- store Google account passwords;
- use TOTP codes directly inside chat;
- grant AI access to the TOTP seed;
- create a general user-login system for WoodFlow customers;
- redesign GitHub branch protection;
- silently authorize merge based on a chat message alone.

## 4. Proposed architecture

### 4.1 Components

**A. Google Authenticator on Piotr Dobrowolski's phone**
- Holds the TOTP account/seed.
- Generates short-lived TOTP codes.
- The seed and codes are never shared with AI.

**B. Product Owner Authorization Verifier**
- A small, separate trusted verifier outside ChatGPT/Claude/Claude Code.
- Presents the exact decision payload before accepting a TOTP code.
- Validates the TOTP code.
- Produces a non-secret authorization record/proof.
- Must not echo the submitted TOTP code into durable logs.

**C. Authorization Record**
Contains only non-secret metadata sufficient to audit the decision, for example:

```text
Approver: Piotr Dobrowolski — Product Owner
Decision: MERGE APPROVED
Repository: woodflow-app/WoodFlow
PR: 123
Verified HEAD SHA: abcdef...
Decision payload hash: <hash>
Authorized at: <UTC timestamp>
Verification result: VERIFIED
Authorization ID: <random unique identifier>
```

The record must never contain:
- TOTP seed;
- TOTP recovery material;
- submitted six-digit code;
- reusable session secret.

### 4.2 Decision payload

Before TOTP verification, the verifier constructs a canonical payload. For merge authorization it must include at minimum:

```text
project = WoodFlow
repository = woodflow-app/WoodFlow
decision = MERGE APPROVED
pr_number = <number>
verified_head_sha = <40-char SHA>
approver = Piotr Dobrowolski — Product Owner
```

The user must see this exact target before confirming.

For a plan/build authorization the payload must identify the exact plan/task/specification version or immutable digest being approved.

### 4.3 Binding and replay protection

A successful TOTP check is not sufficient by itself. The resulting authorization must be tied to the canonical decision payload.

The verifier must generate a unique authorization ID and payload digest. A later consumer validates that:

- the decision type matches;
- repository/project matches;
- PR matches where applicable;
- HEAD SHA matches exactly for merge;
- the payload digest matches the decision presented to the Product Owner;
- the authorization has not already been invalidated or superseded.

An authorization for one SHA must not validate for another SHA.

### 4.4 Merge invalidation rule

`MERGE APPROVED` applies only to the exact independently verified HEAD SHA named in the authorization record.

If PR HEAD changes after authorization:

```text
MERGE AUTHORIZATION: INVALID FOR CURRENT HEAD
STATUS: REQUIRES APPROVAL
Approver: Piotr Dobrowolski — Product Owner
```

The changed HEAD must undergo the required independent verification before a new merge authorization can be issued.

## 5. TOTP handling requirements

1. Use standards-compatible TOTP suitable for Google Authenticator.
2. TOTP seed generation/enrolment must happen in the trusted verifier context, not in AI chat.
3. The seed must never be committed to GitHub.
4. `.env`, logs, crash reports, analytics, clipboard history, screenshots, shell history, and PR output must be considered potential leak paths.
5. Submitted codes must be redacted and not persisted.
6. Rate-limit failed verification attempts.
7. Allow only a narrow clock-skew window appropriate for TOTP.
8. Recovery/re-enrolment must require an explicit Product Owner recovery process; AI must not be able to reset TOTP by itself.

## 6. Authorization evidence and audit trail

The durable evidence should prove what was authorized without claiming that the text record itself cryptographically proves identity.

Minimum evidence:

- Product Owner identity label: `Piotr Dobrowolski — Product Owner`;
- decision type;
- immutable target identifiers;
- UTC authorization timestamp;
- unique authorization ID;
- payload digest;
- verifier result;
- verifier version.

The verifier must clearly distinguish:

```text
AUTHENTICATION VERIFIED
```

from:

```text
TEXT CLAIM ONLY — NOT AUTHENTICATED
```

AI-generated text must never be allowed to upgrade itself from the second state to the first.

## 7. Threat model

### Threat A — TOTP code pasted into chat
**Risk:** AI/chat history receives a live authentication factor.  
**Control:** codes are accepted only by the dedicated verifier. Chat instructions explicitly reject TOTP codes and direct the Product Owner to the verifier.

### Threat B — TOTP seed committed or logged
**Risk:** permanent compromise; attackers can generate future codes.  
**Control:** seed never enters repo/chat; secret storage must be local/OS-protected; repository and logs contain only non-secret evidence.

### Threat C — replay of an old authorization
**Risk:** a valid old approval is reused for another PR/SHA.  
**Control:** authorization is bound to canonical payload + exact identifiers; different payload must fail validation.

### Threat D — new commit after `MERGE APPROVED`
**Risk:** unreviewed code is merged using approval for an older HEAD.  
**Control:** exact-SHA binding; any HEAD change invalidates merge authorization.

### Threat E — copied/fabricated `Piotr Dobrowolski — Product Owner — MERGE APPROVED` text
**Risk:** semantic format is mistaken for authenticated approval.  
**Control:** authenticated state requires verifier evidence; bare text remains `TEXT CLAIM ONLY — NOT AUTHENTICATED`.

### Threat F — compromised AI agent
**Risk:** agent attempts to self-authorize or request secrets.  
**Control:** agent never has TOTP seed; verifier independently checks authentication and immutable payload; AI cannot generate valid verifier evidence.

### Threat G — compromised GitHub account / owner bypass
**Risk:** direct push or merge occurs without valid Product Owner authorization.  
**Control:** verifier evidence must be checked as a governance precondition. Branch/ruleset enforcement is a separate control and is not solved by TOTP alone.

### Threat H — malicious or accidental payload substitution
**Risk:** Product Owner thinks one change is approved while verifier records another.  
**Control:** verifier displays repository, decision, PR/task identifier, and SHA/digest before code entry; authorization record is generated from exactly the displayed canonical payload.

### Threat I — clock manipulation
**Risk:** TOTP verification window is weakened or legitimate codes fail.  
**Control:** trusted system time, narrow skew allowance, explicit failure rather than permissive fallback.

### Threat J — recovery path becomes bypass
**Risk:** attacker or agent resets TOTP more easily than authenticating.  
**Control:** recovery is separate, explicit, high-friction, Product-Owner-controlled, and auditable; AI cannot invoke recovery autonomously.

## 8. Known limitations

1. Google Authenticator/TOTP proves possession of the enrolled TOTP secret at verification time; it does not by itself prove the human legal identity behind the device.
2. If the Product Owner's phone or TOTP seed is compromised, valid approvals may be generated by an attacker until re-enrolment/revocation.
3. TOTP does not fix GitHub ruleset bypass permissions. Repository enforcement remains a separate layer.
4. The quality of the system depends on the verifier itself being trustworthy and correctly binding the visible decision to the generated evidence.
5. This design intentionally does not solve all future multi-user approval requirements; it is scoped to the current Product Owner authorization need.

## 9. Fail-safe rules

- If verifier evidence is missing, invalid, mismatched, stale, or ambiguous: `REQUIRES APPROVAL`.
- If current PR HEAD differs from authorized SHA: `REQUIRES APPROVAL`.
- If an agent sees a TOTP code in chat: do not repeat, store, or treat it as durable approval; instruct the Product Owner to use the verifier.
- If the verifier cannot validate the exact target: STOP; never infer approval.

## 10. Implementation gate after this design

Before executable implementation begins, an Independent Reviewer must check at minimum:

- whether any secret can reach AI or GitHub;
- whether authorization can be replayed across PRs/SHAs;
- whether exact-SHA invalidation is enforced;
- whether logs persist submitted TOTP codes;
- whether recovery creates a weaker bypass;
- whether the evidence format can be fabricated by an AI and mistaken for authenticated proof;
- whether the design accidentally creates a new way to bypass the existing Product Owner/Reviewer separation.

Only after that review may the implementation phase proceed within the already approved scope. No merge to `main` is authorized by this document.

## 11. Current decision state

```text
Piotr Dobrowolski — Product Owner — PLAN + BUILD APPROVED

Scope: design and threat model for Google Authenticator-compatible Product Owner authorization, followed by independent review before implementation.

MERGE APPROVAL: NOT GRANTED
```
