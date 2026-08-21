# Product Owner TOTP Authorization — Design & Threat Model

**Status:** REVISED AFTER INDEPENDENT REVIEW — REQUIRES RE-REVIEW  
**Authentication state:** TEXT CLAIM ONLY — NOT AUTHENTICATED  
**Implementation authorization:** NOT GRANTED BY THIS DOCUMENT  
**Merge authorization:** NOT GRANTED

## 1. Purpose

Design a Product Owner authorization mechanism using Google Authenticator-compatible TOTP without exposing the TOTP secret or six-digit codes to ChatGPT, Claude, Claude Code, GitHub comments, or repository files.

This document is the design and threat-model phase only. It does not itself prove Product Owner identity, authorize executable implementation, or authorize merge.

Any Product Owner approval written inside this document, a PR body, a chat, or other ordinary text must be treated as `TEXT CLAIM ONLY — NOT AUTHENTICATED` unless it is backed by independently verifiable authorization evidence produced by the trusted verifier described below.

## 2. Security goals

The mechanism must ensure that:

1. The TOTP seed remains under Product Owner control and is never stored in chat history, repository content, PR comments, AI prompts, application logs, analytics, or crash reports.
2. Six-digit TOTP codes are entered only into a dedicated verifier surface and are never copied into ChatGPT, Claude, Claude Code, or GitHub.
3. A successful verification creates a durable authorization record that contains no reusable secret.
4. Every authorization is bound to one explicit decision and immutable target data.
5. `MERGE APPROVED` is bound to an exact PR number and exact independently verified HEAD SHA.
6. A new commit after merge authorization makes the previous authorization unusable for the new HEAD.
7. Replaying an old authorization proof for another PR, SHA, decision type, project, nonce, authorization ID, or accepted TOTP time-step must fail.
8. AI agents may verify the resulting proof/status but must not possess enough information to generate a valid Product Owner authorization themselves.
9. The verifier is a separate trust boundary from the WoodFlow Review Bridge and from all AI agents.
10. Security-critical replay, lockout, and authorization-consumption state must be enforced through one strongly consistent authority, not per-edge or eventually consistent state.
11. For PR/SHA-bound decisions, the verifier must independently obtain authoritative GitHub state rather than trusting caller-supplied PR metadata.

## 3. Non-goals

This first design does not attempt to:

- replace Google Authenticator;
- store Google account passwords;
- use TOTP codes directly inside chat;
- grant AI access to the TOTP seed;
- create a general user-login system for WoodFlow customers;
- redesign GitHub branch protection;
- silently authorize merge based on a chat message alone;
- let a PR or document self-declare an authenticated Product Owner decision.

## 4. Proposed architecture

### 4.1 Components

**A. Google Authenticator on the Product Owner's phone**
- Holds the enrolled TOTP account.
- Generates short-lived TOTP codes.
- The seed and codes are never shared with AI.

**B. Product Owner Authorization Verifier**
- A dedicated service separate from ChatGPT, Claude, Claude Code, and `woodflow-review-bridge`.
- Initial deployment target: a separate Cloudflare Worker in the Product Owner-controlled Cloudflare account, with a separate service name, route, bindings, logs, and deployment history.
- The Review Bridge must not have a binding that can read the verifier's TOTP secret or GitHub verifier credential.
- Presents the exact canonical decision payload before accepting a TOTP code.
- Independently resolves authoritative GitHub state for PR/SHA-bound decisions.
- Validates the TOTP code and replay state.
- Produces a non-secret authorization record/proof.
- Never echoes the submitted TOTP code into durable logs or responses.
- Fails closed if required secret storage, authoritative GitHub lookup, replay state, trusted time, or audit persistence is unavailable.

**C. Verifier secret storage**
- The verifier requires the enrolled TOTP seed in order to validate codes.
- The seed must be stored only in a secret binding controlled by the Product Owner, such as Cloudflare Secrets Store / Worker secret storage.
- The verifier's GitHub authentication material must likewise be stored only in verifier-controlled secret bindings and must not be shared with the Review Bridge or AI agents.
- The TOTP seed and GitHub credentials must not exist in source code, Wrangler configuration committed to Git, environment files committed to Git, PRs, chat, screenshots intended for agents, or Review Bridge bindings.
- Enrolment/re-enrolment writes the seed directly into the verifier's secret store through a Product Owner-controlled administrative path.
- Secret values must never be returned by health/status endpoints.
- A future move to a different verifier runtime or secret store is an architecture/security change requiring independent review before use.

**D. Strongly consistent verifier state**
- Initial baseline: one dedicated Cloudflare Durable Object namespace owned by the verifier service is the authoritative state machine for replay prevention, accepted-TOTP-step consumption, authorization-ID/nonce consumption, failed-attempt counters, and lockout state.
- All security-critical state transitions for one Product Owner identity are serialized through that Durable Object before an authorization record is emitted.
- Cloudflare KV must not be used as the authoritative source for these controls because eventually consistent state is insufficient for single-use/replay guarantees.
- D1 or another database may later be used for durable audit/reporting, but it must not replace the strongly consistent authorization-consumption state unless an independent review establishes equivalent consistency semantics.
- The verifier fails closed if the Durable Object state authority is unavailable.

**E. Authoritative GitHub state resolver**
- For decisions bound to a PR or HEAD SHA, the verifier independently queries the GitHub API after receiving the PR number and before presenting the canonical payload.
- The caller may identify the PR number, but caller-supplied HEAD SHA, repository state, mergeability state, or review status is treated as untrusted input and must not become authoritative merely because it was supplied.
- Initial authentication baseline: a dedicated GitHub App installation credential scoped to the `woodflow-app/WoodFlow` repository with the minimum read permissions required to read pull-request and repository metadata. It must not have merge, contents-write, administration, or ruleset-write permission.
- The GitHub App private key / installation authentication material is stored only in verifier-controlled secret storage. Installation access tokens are minted at runtime, kept only in memory for their normal short lifetime, never logged, and never written into authorization records.
- Credential rotation/revocation is Product Owner controlled. Loss of GitHub read authentication causes fail-closed `REQUIRES APPROVAL`; the verifier must never fall back to caller-provided SHA data.
- Immediately before creating a merge authorization record, the verifier re-fetches current PR state and current HEAD SHA and binds the record to that exact authoritative SHA.

**F. Authorization Record**
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
Verifier version: <immutable version>
```

The record must never contain:
- TOTP seed;
- TOTP recovery material;
- submitted six-digit code;
- GitHub private key or installation token;
- reusable session secret.

### 4.2 Verifier trust boundary and operations

The verifier is security-critical infrastructure and must not be treated as trusted merely because it is called a verifier.

For the initial deployment:

- hosting/account ownership: Product Owner-controlled Cloudflare account;
- runtime: dedicated Cloudflare Worker, separate from the Review Bridge;
- secret access: verifier-only secret bindings; no AI/Review Bridge access;
- strongly consistent state: verifier-owned Durable Object namespace;
- authoritative PR state: verifier-only, read-only GitHub App installation access;
- deployment: explicit Product Owner-controlled deployment; no autonomous AI deployment to the verifier;
- source changes: reviewed through the normal WoodFlow change process before deployment;
- runtime logs: metadata only; request bodies, TOTP codes, seed material, GitHub credentials/tokens, recovery material, and authorization secrets are forbidden;
- observability: failed verification counts, lockouts, verifier version, and non-secret authorization IDs may be logged;
- fail-safe: if verifier integrity/version, Durable Object state, GitHub authoritative lookup, trusted time, or required persistence cannot be established, authorization status is `REQUIRES APPROVAL`.

The verifier's own version must be included in every authorization record so later consumers can identify exactly which verifier implementation produced the evidence.

### 4.3 Decision payload

Before TOTP verification, the verifier constructs a canonical payload. For merge authorization it must include at minimum:

```text
project = WoodFlow
repository = woodflow-app/WoodFlow
decision = MERGE APPROVED
pr_number = <number>
verified_head_sha = <40-char SHA independently fetched from GitHub>
approver = Piotr Dobrowolski — Product Owner
nonce = <single-use random value>
```

The Product Owner must see this exact target before confirming. For PR/SHA-bound decisions, the displayed `verified_head_sha` must come from the verifier's own GitHub lookup, never from caller authority.

For a plan/build authorization the payload must identify the exact plan/task/specification version or immutable digest being approved. A generic statement such as `PLAN + BUILD APPROVED` without an immutable target is insufficient.

### 4.4 Binding, atomic consumption, and replay protection

A successful TOTP check is not sufficient by itself. The resulting authorization must be tied to the canonical decision payload.

The verifier must generate a unique authorization ID, single-use nonce, and payload digest. A later consumer validates that:

- the decision type matches;
- repository/project matches;
- PR matches where applicable;
- HEAD SHA matches exactly for merge;
- the payload digest matches the decision presented to the Product Owner;
- the nonce has not been consumed before;
- the authorization ID has not already been invalidated, consumed, or superseded;
- the accepted TOTP time-step has not already been used to mint another authorization.

For the initial Cloudflare implementation, the verifier routes these checks and mutations through the verifier-owned Durable Object. Within one serialized state transition it must verify current replay/lockout state, consume the nonce and accepted TOTP time-step, reserve the authorization ID, and persist the resulting state before returning success. The authorization record is emitted only after that atomic security-state transition succeeds.

An authorization for one SHA must not validate for another SHA. A second concurrent request using the same nonce, authorization ID, or accepted TOTP time-step must lose the serialization race and fail, even if handled by another edge location.

### 4.5 Merge invalidation rule

`MERGE APPROVED` applies only to the exact independently verified HEAD SHA named in the authorization record.

Immediately before issuing `MERGE APPROVED`, the verifier independently fetches the current PR HEAD SHA from GitHub. If it differs from the SHA displayed to the Product Owner earlier in the authorization flow, the verifier must abort and restart the decision presentation; it must not silently substitute the new SHA after TOTP entry.

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
5. Submitted codes must be redacted and must not be persisted.
6. Failed verification attempts are limited to a maximum of **5 failures in a rolling 10-minute window** for the Product Owner verifier identity.
7. Failure backoff is applied before another attempt is accepted: approximately **2 s, 5 s, 15 s, 30 s** for successive failures within the window; the fifth failure triggers lockout.
8. After the fifth failure within the rolling window, verification is locked for **15 minutes** and a non-secret security event is recorded. The lockout cannot be bypassed by changing IP address, browser session, AI agent, or Cloudflare edge location.
9. The failure counter, backoff state, and lockout deadline are authoritative only in the same verifier-owned Durable Object used for replay state. Edge-local memory and eventually consistent KV must not be authoritative for these controls.
10. A successful verification clears the ordinary failure counter only after the authorization record has been durably created; it does not erase audit history.
11. Allow only a narrow clock-skew window appropriate for TOTP; the implementation baseline is the current 30-second step plus at most one adjacent step on either side. A wider window requires a new security review.
12. Recovery/re-enrolment must require an explicit Product Owner recovery process; AI must not be able to reset TOTP by itself.
13. Rate limits, replay state, and lockout state must be enforced server-side in the verifier trust boundary, not only in UI code.

## 6. Authorization evidence and audit trail

The durable evidence should prove what was authorized without claiming that ordinary text by itself cryptographically proves identity.

Minimum evidence:

- Product Owner identity label: `Piotr Dobrowolski — Product Owner`;
- decision type;
- immutable target identifiers;
- authoritative GitHub-resolved HEAD SHA for merge decisions;
- UTC authorization timestamp;
- unique authorization ID;
- single-use nonce identifier or digest;
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

AI-generated text, PR text, repository prose, commit messages, or chat statements must never be allowed to upgrade themselves from the second state to the first.

## 7. Threat model

### Threat A — TOTP code pasted into chat
**Risk:** AI/chat history receives a live authentication factor.  
**Control:** codes are accepted only by the dedicated verifier. Chat instructions explicitly reject TOTP codes and direct the Product Owner to the verifier.

### Threat B — TOTP seed committed, logged, or exposed through the Review Bridge
**Risk:** permanent compromise; attackers can generate future codes.  
**Control:** seed never enters repo/chat; it exists only in verifier-only secret storage. The Review Bridge has no binding or API response that reveals it. Logs contain only non-secret evidence.

### Threat C — replay of an old authorization
**Risk:** a valid old approval is reused for another PR/SHA or repeated for the same target.  
**Control:** authorization is bound to canonical payload + exact identifiers + single-use nonce; replay/consumption state is atomically serialized through a verifier-owned Durable Object, so concurrent edge requests cannot both consume the same nonce/time-step.

### Threat D — new commit after `MERGE APPROVED`
**Risk:** unreviewed code is merged using approval for an older HEAD.  
**Control:** exact-SHA binding; authoritative SHA is independently fetched from GitHub before authorization issuance; any HEAD change invalidates merge authorization.

### Threat E — copied/fabricated `Piotr Dobrowolski — Product Owner — MERGE APPROVED` text
**Risk:** semantic format is mistaken for authenticated approval.  
**Control:** authenticated state requires verifier evidence; bare text remains `TEXT CLAIM ONLY — NOT AUTHENTICATED`.

### Threat F — compromised AI agent
**Risk:** agent attempts to self-authorize, supply stale PR metadata, or request secrets.  
**Control:** agent never has TOTP seed or verifier GitHub credentials; verifier independently fetches authoritative PR state and checks immutable payload; AI cannot generate valid verifier evidence.

### Threat G — compromised GitHub account / owner bypass
**Risk:** direct push or merge occurs without valid Product Owner authorization.  
**Control:** verifier evidence must be checked as a governance precondition. Branch/ruleset enforcement is a separate control and is not solved by TOTP alone.

### Threat H — malicious or accidental payload substitution
**Risk:** Product Owner thinks one change is approved while verifier records another.  
**Control:** verifier independently resolves authoritative GitHub state, then displays repository, decision, PR/task identifier, SHA/digest, and nonce before code entry; authorization record is generated from exactly the displayed canonical payload.

### Threat I — clock manipulation
**Risk:** TOTP verification window is weakened or legitimate codes fail.  
**Control:** trusted system time, explicit bounded skew, and failure rather than permissive fallback.

### Threat J — recovery path becomes bypass
**Risk:** attacker or agent resets TOTP more easily than authenticating.  
**Control:** recovery is separate, explicit, high-friction, Product-Owner-controlled, and auditable; AI cannot invoke recovery autonomously.

### Threat K — verifier compromise
**Risk:** attacker controlling the verifier can read the seed, GitHub credential, falsify verification results, or mint authorization records.  
**Control:** verifier is isolated from the Review Bridge and AI agents; uses verifier-only secret storage and strongly consistent state; has explicit deployment/version evidence; changes require normal review; consumers fail closed if verifier version/evidence is missing or untrusted.

### Threat L — brute-force TOTP guessing
**Risk:** six-digit code space is small enough that an unrestricted online verifier can be attacked.  
**Control:** global server-side rolling failure limit, escalating backoff, 15-minute lockout after five failures, audit event, and no IP-, session-, agent-, or edge-location-only bypass; counters are serialized through the verifier-owned Durable Object.

### Threat M — caller supplies stale or fabricated GitHub HEAD SHA
**Risk:** Product Owner authorizes a payload that does not correspond to the repository's actual current PR state.  
**Control:** caller SHA is never authoritative; verifier independently queries GitHub using its verifier-only read credential and fails closed if authoritative lookup is unavailable or mismatched.

## 8. Known limitations

1. Google Authenticator/TOTP proves possession of the enrolled TOTP secret at verification time; it does not by itself prove the human legal identity behind the device.
2. If the Product Owner's phone, Cloudflare account, verifier runtime, GitHub App credential, or TOTP seed is compromised, valid approvals may be generated by an attacker until re-enrolment/revocation.
3. TOTP does not fix GitHub ruleset bypass permissions. Repository enforcement remains a separate layer.
4. The verifier remains a high-value trusted component; isolation, least-privilege GitHub read access, strongly consistent replay state, and evidence reduce risk but do not make verifier compromise impossible.
5. This design intentionally does not solve all future multi-user approval requirements; it is scoped to the current Product Owner authorization need.
6. The concrete Durable Object, rate-limit, skew, and GitHub App baselines in this document are security design choices and must themselves pass independent review before implementation.

## 9. Fail-safe rules

- If verifier evidence is missing, invalid, mismatched, stale, or ambiguous: `REQUIRES APPROVAL`.
- If current authoritative PR HEAD differs from authorized SHA: `REQUIRES APPROVAL`.
- If an agent sees a TOTP code in chat: do not repeat, store, or treat it as durable approval; instruct the Product Owner to use the verifier.
- If the verifier cannot validate the exact target: STOP; never infer approval.
- If verifier secret storage, Durable Object replay/lockout state, authoritative GitHub lookup, trusted time, or audit persistence is unavailable: STOP; never fall back to text approval or caller-supplied SHA.
- If a document or PR claims `APPROVED` without verifier evidence: treat it as `TEXT CLAIM ONLY — NOT AUTHENTICATED`.

## 10. Implementation gate after this design

Before executable implementation begins, an Independent Reviewer must check at minimum:

- whether any secret can reach AI, the Review Bridge, or GitHub;
- whether verifier secret storage and trust boundaries are concrete and enforceable;
- whether Durable Object state transitions make nonce, authorization-ID, accepted-TOTP-step, failure-counter, and lockout handling strongly consistent and race-safe;
- whether authorization can be replayed across PRs/SHAs/nonces or reused within one TOTP time-step;
- whether authoritative PR/HEAD state is independently fetched from GitHub using least-privilege verifier-only credentials;
- whether exact-SHA invalidation is enforced;
- whether logs persist submitted TOTP codes or GitHub credentials/tokens;
- whether brute-force protections are global, server-side, and testable;
- whether recovery creates a weaker bypass;
- whether the evidence format can be fabricated by an AI and mistaken for authenticated proof;
- whether the design accidentally creates a new way to bypass the existing Product Owner/Reviewer separation.

A successful independent design review does **not** itself authorize implementation. Executable implementation requires a separate explicit Product Owner authorization bound to the reviewed design version/digest. Merge requires its own separate authorization bound to the exact independently verified PR HEAD SHA.

## 11. Current decision state

```text
DESIGN STATUS: REVISED AFTER INDEPENDENT REVIEW
AUTHENTICATION STATE: TEXT CLAIM ONLY — NOT AUTHENTICATED
IMPLEMENTATION AUTHORIZATION: NOT GRANTED BY THIS DOCUMENT
MERGE APPROVAL: NOT GRANTED
NEXT REQUIRED GATE: INDEPENDENT RE-REVIEW OF THIS REVISION
```

This section intentionally does not claim authenticated Product Owner approval. Until the trusted verifier exists, ordinary repository text cannot prove the identity/authenticity of a Product Owner decision. The document therefore remains a design artifact awaiting re-review and, if it passes, a separate explicit Product Owner implementation decision.
