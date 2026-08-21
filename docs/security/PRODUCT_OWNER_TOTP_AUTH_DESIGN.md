# Product Owner TOTP Authorization — Design & Threat Model

**Status:** REVISED — REQUIRES INDEPENDENT RE-REVIEW  
**Authentication state:** TEXT CLAIM ONLY — NOT AUTHENTICATED  
**Implementation authorization:** NOT GRANTED BY THIS DOCUMENT  
**Merge authorization:** NOT GRANTED

This file is a temporary Phase 1 security design/review artifact. It is subordinate to `docs/WoodFlow_Handbook.md` and must not be treated as an alternate WoodFlow source of truth. Review execution IDs, model outputs, external blob hashes, and Cloudflare log identifiers are deliberately not embedded here as durable authority; the review system keeps those as execution evidence outside this design artifact.

References below to a review/orchestration service are separation requirements only. The verifier design does not depend on any particular review bridge existing.

## 1. Purpose

Design a Product Owner authorization mechanism using Google Authenticator-compatible TOTP without exposing the TOTP seed or six-digit codes to ChatGPT, Claude, Claude Code, GitHub comments, or repository files.

This document defines security requirements and a threat model only. It does not prove Product Owner identity, authorize executable implementation, or authorize merge.

Any approval written in a document, PR body, commit message, chat, or other ordinary text remains `TEXT CLAIM ONLY — NOT AUTHENTICATED` unless it is backed by independently verifiable evidence produced by the trusted verifier defined here.

## 2. Security goals

The mechanism must ensure that:

1. The TOTP seed remains under Product Owner control and never appears in repository content, chat history, AI prompts, PR comments, application logs, analytics, or crash reports.
2. Six-digit TOTP codes are entered only into the dedicated verifier surface and are never copied into AI tools or GitHub.
3. Successful verification creates a durable authorization record containing no reusable authentication secret.
4. Every authorization is bound to one explicit decision and immutable target data.
5. `MERGE APPROVED` is bound to an exact repository, PR number, and independently obtained current HEAD SHA.
6. Any change to PR HEAD invalidates authorization issued for the previous HEAD.
7. Replaying an old authorization across PRs, SHAs, decisions, nonces, authorization IDs, or accepted TOTP time-steps must fail.
8. AI agents may validate non-secret authorization evidence but must not possess enough secret material to mint valid Product Owner authorization themselves.
9. The verifier is a separate trust boundary from all AI and review/orchestration services.
10. Replay, lockout, failed-attempt, and authorization-consumption state is controlled by one strongly consistent authority rather than edge-local or eventually consistent state.
11. For PR/SHA-bound decisions, the verifier independently obtains authoritative GitHub state instead of trusting caller-supplied PR metadata.
12. Failure of any security-critical dependency causes fail-closed `REQUIRES APPROVAL` behavior.

## 3. Non-goals

This design does not attempt to:

- replace Google Authenticator;
- store Google account passwords;
- send TOTP codes through chat;
- grant AI access to the TOTP seed;
- create a general WoodFlow customer-login system;
- redesign GitHub branch protection;
- let a PR or document self-declare authenticated Product Owner approval;
- solve future multi-owner or multi-approver governance;
- authorize implementation or merge merely because this design passes review.

## 4. Why dedicated verifier infrastructure is justified

The additional infrastructure is accepted only because the target security property cannot be achieved safely by ordinary chat or GitHub text approval.

### 4.1 Problem being solved

GitHub-native comments, reviews, labels, commit messages, and chat statements are useful workflow evidence but are not an independent second factor controlled exclusively by the Product Owner. An AI agent or compromised GitHub session must not be able to manufacture the same evidence that represents authenticated Product Owner authorization.

### 4.2 Simpler alternatives considered

**GitHub approval/review only:** rejected as the sole authorization factor because a compromised GitHub account or bypass-capable owner session remains inside the same trust boundary.

**Approval phrase in chat or PR text:** rejected because text is copyable and forgeable and cannot prove possession of a separate authentication secret.

**TOTP code pasted into chat/GitHub:** rejected because it exposes a live authentication factor to systems that should never possess it.

**Single stateless Worker with only KV/local counters:** rejected because replay and lockout guarantees require atomic, strongly consistent single-use state across concurrent edge requests.

### 4.3 Complexity accepted

The baseline therefore introduces only the components needed for the required guarantees:

- one dedicated verifier Worker;
- verifier-only secret storage;
- one strongly consistent Durable Object authority for replay/lockout state;
- one least-privilege read-only GitHub App identity for authoritative PR/HEAD lookup.

No write, merge, administration, or ruleset permission is required by the verifier. If a materially simpler architecture can later provide the same independent-factor, exact-target, replay-safe, fail-closed guarantees, it should replace this design through the normal review process.

## 5. Proposed architecture

### 5.1 Components

**A. Google Authenticator on the Product Owner's phone**

- Holds the enrolled TOTP account.
- Generates short-lived TOTP codes.
- The seed and codes are never shared with AI.

**B. Product Owner Authorization Verifier**

- Dedicated service separate from ChatGPT, Claude, Claude Code, and any review/orchestration service.
- Initial deployment target: a separate Cloudflare Worker in the Product Owner-controlled Cloudflare account.
- Uses separate service name, route, bindings, secrets, logs, and deployment history.
- No review/orchestration service receives a binding that can read verifier TOTP or GitHub credentials.
- Presents the exact canonical decision payload before TOTP entry.
- Independently resolves authoritative GitHub state for PR/SHA-bound decisions.
- Validates TOTP plus replay/lockout state.
- Produces only non-secret authorization evidence.
- Never echoes submitted TOTP codes into durable logs or responses.
- Fails closed if required secret storage, GitHub lookup, strongly consistent state, trusted time, or audit persistence is unavailable.

**C. Verifier secret storage**

- TOTP seed is stored only in verifier-controlled Cloudflare secret storage.
- GitHub App private-key/authentication material is stored only in verifier-controlled secret storage.
- Secrets must not exist in committed source, committed Wrangler configuration, repository `.env` files, PRs, chat, screenshots intended for agents, analytics, or review/orchestration bindings.
- Enrolment/re-enrolment writes the TOTP seed directly through a Product Owner-controlled administrative path.
- Secret values are never returned from health or status endpoints.
- Moving to another secret store/runtime is a security architecture change requiring independent review.

**D. Strongly consistent security state**

Initial baseline: one dedicated Cloudflare Durable Object namespace owned by the verifier service.

It is authoritative for:

- nonce creation/consumption;
- authorization-ID reservation/consumption;
- accepted-TOTP-time-step consumption;
- failed-attempt counters;
- backoff state;
- lockout deadlines;
- invalidation/supersession state required for authorization safety.

All security-critical state transitions for the Product Owner verifier identity are serialized through this Durable Object before an authorization record is emitted.

Cloudflare KV must not be the authority for these controls because eventual consistency is insufficient for single-use and replay guarantees. D1 or another database may be used for audit/reporting, but may replace the security-state authority only after independent review establishes equivalent consistency and race-safety semantics.

If the Durable Object authority is unavailable, verification fails closed.

**E. Authoritative GitHub state resolver**

For PR/SHA-bound decisions, the verifier independently queries GitHub after receiving the PR number and before presenting the canonical payload.

- Caller may identify the PR number.
- Caller-supplied HEAD SHA, mergeability, review status, repository state, or branch state is untrusted input.
- Initial authentication baseline: dedicated GitHub App installation scoped only to `woodflow-app/WoodFlow` with minimum read permissions needed for repository and pull-request metadata.
- The verifier GitHub identity must not have merge, contents-write, administration, or ruleset-write permission.
- Installation access tokens are minted at runtime, kept only in memory for their short normal lifetime, never logged, and never written into authorization records.
- Credential rotation/revocation remains Product Owner controlled.
- Loss of GitHub read authentication causes `REQUIRES APPROVAL`; there is no fallback to caller-provided SHA.

**F. Authorization record**

Example non-secret evidence:

```text
Approver role: Product Owner
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

### 5.2 Verifier trust boundary and operations

For the initial deployment:

- hosting/account ownership: Product Owner-controlled Cloudflare account;
- runtime: dedicated Cloudflare Worker separate from review/orchestration services;
- secret access: verifier-only bindings;
- strongly consistent state: verifier-owned Durable Object namespace;
- authoritative PR state: verifier-only read-only GitHub App installation access;
- deployment: explicit Product Owner-controlled deployment; no autonomous AI deployment to the verifier;
- source changes: normal WoodFlow review process before deployment;
- runtime logs: metadata only; request bodies, TOTP codes, seeds, GitHub credentials/tokens, recovery material, and authorization secrets are forbidden;
- observability may include failed-verification counts, lockouts, verifier version, and non-secret authorization IDs;
- fail-safe: inability to establish verifier version/integrity, Durable Object state, GitHub lookup, trusted time, or required persistence means `REQUIRES APPROVAL`.

Every authorization record includes verifier version so consumers can identify which verifier implementation produced it.

## 6. Decision payload and authoritative target binding

Before TOTP verification, the verifier constructs a canonical payload. For merge authorization it includes at minimum:

```text
project = WoodFlow
repository = woodflow-app/WoodFlow
decision = MERGE APPROVED
pr_number = <number>
verified_head_sha = <40-char SHA independently fetched from GitHub>
approver_role = Product Owner
nonce = <single-use random value>
```

The Product Owner sees this exact target before confirming.

For PR/SHA-bound decisions, `verified_head_sha` comes from the verifier's own GitHub lookup, never caller authority.

For plan/build authorization, the payload identifies the exact plan/task/specification version or immutable digest being approved. A generic `PLAN + BUILD APPROVED` without an immutable target is insufficient.

Immediately before issuing merge authorization, the verifier re-fetches current PR state and HEAD SHA. If the SHA differs from the SHA displayed before TOTP entry, the verifier aborts and restarts target presentation. It must never silently substitute a new SHA after authentication.

## 7. Atomic consumption and replay protection

A successful TOTP check is not sufficient by itself.

The verifier generates a unique authorization ID, single-use nonce, and payload digest. A valid consumer must establish that:

- decision type matches;
- repository/project matches;
- PR matches where applicable;
- HEAD SHA matches exactly for merge;
- payload digest matches the decision shown to the Product Owner;
- nonce is unused;
- authorization ID is not invalidated, consumed, or superseded;
- accepted TOTP time-step has not already minted another authorization.

The verifier routes these checks and mutations through the verifier-owned Durable Object. Within one serialized state transition it:

1. verifies current replay and lockout state;
2. consumes the nonce;
3. consumes the accepted TOTP time-step;
4. reserves the authorization ID;
5. persists the resulting state;
6. only then returns successful authorization evidence.

A concurrent request using the same nonce, authorization ID, or accepted TOTP time-step must lose the serialization race and fail, regardless of Cloudflare edge location.

An authorization for one SHA never validates for another SHA.

## 8. Merge invalidation rule

`MERGE APPROVED` applies only to the exact authoritative HEAD SHA recorded in the authorization.

If current PR HEAD changes after authorization:

```text
MERGE AUTHORIZATION: INVALID FOR CURRENT HEAD
STATUS: REQUIRES APPROVAL
Approver role: Product Owner
```

The new HEAD must undergo the required independent verification before a new merge authorization can be issued.

## 9. TOTP handling requirements

1. Use standards-compatible TOTP suitable for Google Authenticator.
2. TOTP seed generation/enrolment happens in the trusted verifier context, never AI chat.
3. Seed is never committed to GitHub.
4. Logs, crash reports, analytics, clipboard history, screenshots, shell history, repository files, and PR output are treated as possible leak paths.
5. Submitted codes are redacted and never persisted.
6. Failed verification attempts are limited to a maximum of **5 failures in a rolling 10-minute window** for the verifier identity.
7. Backoff is approximately **2 s, 5 s, 15 s, 30 s** for successive failures; the fifth failure triggers lockout.
8. After the fifth failure within the rolling window, verification locks for **15 minutes** and a non-secret security event is recorded.
9. Lockout cannot be bypassed by changing IP address, browser session, AI agent, or Cloudflare edge location.
10. Failure counter, backoff state, and lockout deadline are authoritative only in the same verifier-owned Durable Object used for replay state.
11. Successful authorization clears the ordinary failure counter only after durable authorization state is created; audit history remains.
12. Clock-skew baseline is the current 30-second TOTP step plus at most one adjacent step on either side. Wider tolerance requires new security review.
13. Recovery/re-enrolment requires an explicit Product Owner-controlled recovery process; AI cannot reset TOTP.
14. All rate limits, replay state, and lockout state are enforced server-side, not only in UI code.

## 10. Authorization evidence and audit trail

Durable evidence proves what was authorized without claiming that ordinary text alone proves identity.

Minimum evidence:

- approver role: `Product Owner`;
- decision type;
- immutable target identifiers;
- authoritative GitHub-resolved HEAD SHA for merge decisions;
- UTC authorization timestamp;
- unique authorization ID;
- single-use nonce identifier or digest;
- payload digest;
- verifier result;
- verifier version.

The verifier distinguishes:

```text
AUTHENTICATION VERIFIED
```

from:

```text
TEXT CLAIM ONLY — NOT AUTHENTICATED
```

AI-generated text, PR text, repository prose, commit messages, or chat statements can never upgrade themselves from the second state to the first.

## 11. Threat model

### Threat A — TOTP code pasted into chat
**Risk:** AI/chat history receives a live authentication factor.  
**Control:** codes are accepted only by the dedicated verifier.

### Threat B — TOTP seed or GitHub credential exposed
**Risk:** attacker can generate codes or falsify authoritative target lookup.  
**Control:** verifier-only secret storage; no AI/review-service binding; no secret logging.

### Threat C — replay of old authorization
**Risk:** valid evidence is reused for another PR/SHA or repeated for the same target.  
**Control:** canonical target binding plus nonce, authorization ID, and TOTP-step consumption serialized through Durable Object state.

### Threat D — new commit after `MERGE APPROVED`
**Risk:** approval for an older HEAD is reused.  
**Control:** exact-SHA binding and authoritative re-fetch; changed HEAD invalidates authorization.

### Threat E — copied/fabricated approval text
**Risk:** semantic text is mistaken for authenticated approval.  
**Control:** only verifier evidence can produce `AUTHENTICATION VERIFIED`; bare text remains `TEXT CLAIM ONLY — NOT AUTHENTICATED`.

### Threat F — compromised AI agent
**Risk:** agent tries to self-authorize, supply stale PR metadata, or request secrets.  
**Control:** AI has neither TOTP seed nor verifier GitHub credential; caller metadata is untrusted.

### Threat G — compromised GitHub account / owner bypass
**Risk:** direct push or merge occurs without verifier authorization.  
**Control:** verifier evidence is a separate governance precondition; branch/ruleset enforcement remains a separate control.

### Threat H — payload substitution
**Risk:** Product Owner sees one target while evidence records another.  
**Control:** verifier resolves target itself and generates the record from exactly the displayed canonical payload.

### Threat I — clock manipulation
**Risk:** TOTP window is weakened or legitimate codes fail.  
**Control:** trusted time, bounded skew, fail-closed behavior.

### Threat J — recovery becomes bypass
**Risk:** reset path is weaker than normal authentication.  
**Control:** separate, explicit, Product Owner-controlled, auditable recovery; no autonomous AI recovery.

### Threat K — verifier compromise
**Risk:** attacker reads secrets or mints authorization evidence.  
**Control:** isolated service, verifier-only secrets, strongly consistent state, least-privilege GitHub access, explicit deployment/version evidence, fail-closed consumers.

### Threat L — brute-force TOTP guessing
**Risk:** six-digit space permits online guessing if unrestricted.  
**Control:** global rolling failure limit, escalating backoff, 15-minute lockout, audit event, and Durable Object-backed counters.

### Threat M — stale/fabricated caller SHA
**Risk:** authorization targets a SHA not matching current GitHub state.  
**Control:** caller SHA is never authoritative; verifier independently queries GitHub.

## 12. Known limitations

1. TOTP proves possession of the enrolled TOTP secret at verification time; it does not by itself prove a human legal identity.
2. Compromise of the Product Owner device, Cloudflare account, verifier runtime, GitHub App credential, or TOTP seed can enable fraudulent authorization until revocation/re-enrolment.
3. TOTP does not fix GitHub ruleset bypass permissions.
4. The verifier remains a high-value trusted component; isolation and least privilege reduce but do not eliminate compromise risk.
5. This design is scoped to a single Product Owner authorization need and does not define future multi-user approval.
6. Durable Object, rate-limit, skew, and GitHub App choices remain security design choices that must pass independent review before implementation.

## 13. Fail-safe rules

- Missing, invalid, mismatched, stale, or ambiguous verifier evidence => `REQUIRES APPROVAL`.
- Current authoritative PR HEAD differs from authorized SHA => `REQUIRES APPROVAL`.
- TOTP code appears in chat => do not repeat, store, or treat it as approval.
- Verifier cannot validate exact target => STOP.
- Secret storage, Durable Object state, GitHub lookup, trusted time, or audit persistence unavailable => STOP; never fall back to text approval or caller-supplied SHA.
- Document/PR claims `APPROVED` without verifier evidence => `TEXT CLAIM ONLY — NOT AUTHENTICATED`.

## 14. Implementation gate after this design

Before executable implementation begins, an Independent Reviewer must check at minimum:

- secret isolation from AI/review services/GitHub;
- verifier trust boundary and secret storage;
- Durable Object atomicity for nonce, authorization ID, TOTP-step, failure counter, and lockout state;
- replay prevention across PRs/SHAs/nonces and concurrent requests;
- independent GitHub PR/HEAD lookup using least-privilege verifier credentials;
- exact-SHA invalidation;
- absence of TOTP/GitHub credential material in logs;
- global server-side brute-force protection;
- recovery-path strength;
- resistance to fabricated textual approval evidence;
- preservation of Product Owner / Independent Reviewer separation;
- whether the accepted infrastructure complexity remains proportionate to the security value described in Section 4.

A successful independent design review does **not** authorize implementation. Executable implementation requires a separate explicit Product Owner authorization bound to the reviewed design version/digest. Merge requires a separate authorization bound to the exact independently verified PR HEAD SHA.

## 15. Current decision state

```text
DESIGN STATUS: REVISED — REQUIRES INDEPENDENT RE-REVIEW
AUTHENTICATION STATE: TEXT CLAIM ONLY — NOT AUTHENTICATED
IMPLEMENTATION AUTHORIZATION: NOT GRANTED BY THIS DOCUMENT
MERGE APPROVAL: NOT GRANTED
NEXT REQUIRED GATE: INDEPENDENT RE-REVIEW
```

This document intentionally contains no authenticated Product Owner approval claim. Until a trusted verifier exists, ordinary repository text cannot itself authenticate a Product Owner decision.
