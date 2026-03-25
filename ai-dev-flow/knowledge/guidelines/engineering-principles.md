# Engineering Principles Reference

This is the shared engineering principles reference for the AI Dev Flow. It is read by `/flow-ta` (Tech Assessment) and `/flow-code` (Implementation) to ensure consistency.

## Clean Code (Robert C. Martin)

- **Functions do one thing** — If you can describe what a function does with "and", split it.
- **Meaningful names** — Names reveal intent. No abbreviations (except universally understood ones like `id`, `url`). No single-letter variables except loop counters and lambdas.
- **Small functions** — If a function exceeds ~20 lines, consider decomposition.
- **No side effects** — Functions do what their name says and nothing more.
- **Command-Query Separation** — Functions either perform an action (command) or return data (query), not both.
- **DRY, but don't over-abstract** — Three instances of duplication is the threshold. Two might be coincidence.
- **Boy Scout Rule** — Leave the code cleaner than you found it. But don't refactor unrelated code — that belongs in a separate PR.
- **Comments explain WHY, not WHAT** — If code needs a comment explaining what it does, the code should be rewritten to be clearer. Comments are for business context, warnings, and non-obvious decisions.

## SOLID Principles

- **S — Single Responsibility:** Each module/class has one reason to change. One actor, one responsibility.
- **O — Open/Closed:** Open for extension, closed for modification. Use interfaces and composition, not modification of existing code.
- **L — Liskov Substitution:** Subtypes must be substitutable for their base types. If your `Square extends Rectangle` breaks when you call `setWidth()`, your hierarchy is wrong.
- **I — Interface Segregation:** No client should depend on methods it doesn't use. Prefer small, focused interfaces over fat ones.
- **D — Dependency Inversion:** High-level modules depend on abstractions, not concretions. Inject dependencies — don't instantiate them.

## Clean Architecture & Hexagonal

- **Dependency direction** — Dependencies point inward. Domain logic knows nothing about frameworks, databases, or HTTP.
- **Use Cases / Application Services** — Orchestrate domain logic. One use case per business operation.
- **Ports & Adapters** — Define ports (interfaces) in the domain. Implement adapters (concrete implementations) in the infrastructure layer.
- **Domain stays pure** — No framework imports, no database queries, no HTTP in domain entities or value objects.
- **Follow what the codebase already does** — If the project has a different layering approach, follow it. Clean Architecture is a guideline, not a religion.

## Domain-Driven Design (Eric Evans)

- **Ubiquitous Language** — Use the same terms the business uses. If the business says "Order", don't call it `PurchaseTransaction` in code.
- **Entities** — Objects with identity that persists over time (e.g., `User`, `Order`). Identity, not attributes, defines equality.
- **Value Objects** — Objects defined by their attributes, not identity (e.g., `Money`, `Address`, `Email`). Immutable. Two `Money(100, "USD")` are equal.
- **Aggregates** — Cluster of entities and value objects with a root that enforces invariants. External code only references the aggregate root.
- **Domain Events** — When something important happens in the domain, emit an event (`OrderPlaced`, `PaymentFailed`). Other parts of the system react.
- **Repositories** — Abstract data access behind a collection-like interface. The domain doesn't know about SQL or MongoDB.
- **Apply DDD only where complexity warrants it.** A simple CRUD module doesn't need aggregates and domain events.

## RESTful Design (when building APIs)

- **Resources, not actions** — URLs represent resources (`/orders`, `/users/123`), not actions (`/getOrders`, `/createUser`).
- **HTTP verbs have meaning** — GET (read), POST (create), PUT (full update), PATCH (partial update), DELETE (remove).
- **Status codes are a contract** — 200 OK, 201 Created, 204 No Content, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable Entity, 429 Too Many Requests, 500 Internal Server Error.
- **Consistent error format** — Every error returns the same structure. Match the existing project convention.
- **HATEOAS when appropriate** — Hypermedia links help clients navigate the API without hardcoding URLs.
- **Versioning** — Follow the project's API versioning strategy (URL path, header, or query param).

## Design Patterns — When to Use Each

Don't memorize patterns — understand the problems they solve:

| Problem | Pattern | Example |
|---------|---------|---------|
| Need to create objects without specifying exact class | **Factory** | `PaymentProcessorFactory.create(type)` |
| Need to swap algorithms at runtime | **Strategy** | Different tax calculation strategies per country |
| Need to react to state changes | **Observer/Event** | Notify email service when order is placed |
| Need to adapt an incompatible interface | **Adapter** | Wrap a third-party SDK behind your own interface |
| Need to add behavior without modifying class | **Decorator** | Add caching, logging, or retry around a service |
| Need to ensure only one instance | **Singleton** | Database connection pool (use DI container instead when possible) |
| Need to build complex objects step by step | **Builder** | Constructing a complex query or configuration |
| Need to decouple command execution from invocation | **Command** | Undo/redo, job queues, audit trails |
| Need a simplified interface to a complex subsystem | **Facade** | Simple API over multiple microservices |
| Need to traverse a collection without exposing internals | **Iterator** | Custom collection traversal (most languages have this built-in) |

**Rule:** Don't introduce a pattern unless the code needs it. Premature patterns add complexity without benefit.

## Algorithmic Thinking & Data Structures

Choose the right data structure:

| Need | Use | Why |
|------|-----|-----|
| Fast lookup by key | HashMap / Dictionary | O(1) average |
| Ordered collection, frequent iteration | Array / List | O(1) index access, cache-friendly |
| Unique values, membership testing | Set / HashSet | O(1) lookup |
| FIFO processing | Queue / Deque | O(1) enqueue/dequeue |
| LIFO / undo operations | Stack | O(1) push/pop |
| Sorted data, range queries | Balanced BST / SortedSet | O(log n) operations |
| Priority processing | Priority Queue / Heap | O(log n) insert, O(1) peek |
| Hierarchical data | Tree | Natural representation of parent-child |
| Relationships / connections | Graph | When entities have complex relationships |

- **Know your Big O** — O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2^n). Anything O(n²) or worse in a hot path is a red flag.
- **Space vs Time trade-offs** — Caching trades memory for speed. Compression trades CPU for storage. Know which resource is scarce.
- **Watch for N+1** — Database queries in loops, API calls in loops, nested iterations over large datasets. Batch instead.
- **Avoid premature optimization** — But don't write obviously slow code either. Profile before optimizing.

## Functional Programming (where applicable)

- **Prefer immutability** — Don't mutate state. Create new values. Use `const`, `readonly`, `final`, `freeze`.
- **Pure functions** — Same input always produces same output. No side effects. Easy to test, easy to reason about.
- **Composition over inheritance** — Build complex behavior from simple functions using pipes, chains, or composition.
- **Isolate side effects** — Push I/O, database, and network calls to the edges. Keep the core logic pure.
- **Higher-order functions** — `map`, `filter`, `reduce` over manual loops when they express intent more clearly.
- **Don't force FP everywhere** — A stateful class with clear encapsulation is better than a tangled web of closures.

## Error Handling

- **Follow project patterns** — Consistency matters more than your personal preference.
- **Typed/structured errors** — Use the project's error types. Create specific errors for specific failures.
- **Never swallow errors silently** — Every catch block must log, rethrow, or handle meaningfully. `catch(e) {}` is a bug.
- **Fail fast** — Validate inputs at the boundary. Don't let bad data propagate deep into the system.
- **Error messages include context** — What happened, what was expected, what data was involved (without PII), what to do about it.
- **Distinguish recoverable from unrecoverable** — Retry on transient errors (network timeout). Fail on permanent errors (invalid input). Don't retry permanent errors.

## Code Smells — Recognize and Fix

| Smell | Signal | Fix |
|-------|--------|-----|
| **Long function** | > 20 lines, hard to name | Extract smaller functions |
| **Long parameter list** | > 3-4 params | Introduce parameter object or builder |
| **God class** | Does too many things | Split by responsibility |
| **Feature envy** | Method uses more data from another class than its own | Move method to where the data lives |
| **Primitive obsession** | Using strings/numbers instead of domain types | Create Value Objects (`Email`, `Money`, `UserId`) |
| **Shotgun surgery** | One change requires editing many files | Consolidate related logic |
| **Divergent change** | One class changes for multiple reasons | Split by Single Responsibility |
| **Dead code** | Unreachable code, unused variables | Delete it. Git has history. |
| **Comments explaining what** | `// increment counter by 1` | Rewrite the code to be self-explanatory |
| **Magic numbers** | `if (status === 3)` | Use constants or enums |
| **Boolean blindness** | `doThing(true, false, true)` | Use named options or enums |

## Security (Non-Negotiable)

- **Validate all external input** — Never trust data from outside the system boundary.
- **Sanitize outputs** — Prevent XSS, template injection, and log injection.
- **Parameterized queries always** — Never concatenate user input into queries. No exceptions.
- **Principle of least privilege** — Don't request more permissions than needed.
- **No secrets in code** — No passwords, tokens, API keys, or PII in source code or logs.
- **OWASP Top 10 awareness** — Broken access control (#1), security misconfiguration (#2), supply chain (#3). Check your code against these.

## Observability

- **Structured logging** — Follow the project's logging pattern. Use structured fields, not string concatenation.
- **Log levels matter** — DEBUG for development, INFO for normal flow, WARN for recoverable issues, ERROR for failures that need attention.
- **Correlation IDs** — Propagate request IDs across service boundaries.
- **Metrics** — If specified, instrument them using the project's metrics library.

## Language-Specific Excellence

- **Read the project's existing code first** — Whatever idioms the project uses, follow them.
- **Use the standard library** — Don't import a library for something the language already provides.
- **Follow the language's conventions** — camelCase in JS/TS, snake_case in Python/Ruby/Rust, PascalCase in C#/Go types.
- **Leverage type systems** — In typed languages, let the type system catch errors at compile time. Use union types, generics, branded types, and enums to make invalid states unrepresentable.
- **Async patterns** — Use the language's native async model correctly (async/await, Promises, goroutines, tokio, etc.).
- **Error handling idioms** — Exceptions in Java/Python/C#, Result types in Rust/Go, Either in FP languages. Follow the ecosystem convention.
- **Package management** — Use the standard package manager. Pin versions for production dependencies.
