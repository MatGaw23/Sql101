# SQL Learning Game – High Level Context (HL_Context)

> Purpose: This file gives an AI coding agent the shared context needed to collaboratively build a C++ "game" that teaches SQL through progressive, interactive challenges using modern C++ and the `sqlpp11` library.

---
## 1. Vision Statement
An interactive, extensible C++ console (initially) game that incrementally trains SQL skills (from basic SELECTs to advanced analytical queries) through narrative quests, puzzles, adaptive feedback, and automated validation of user‑written SQL against dynamically generated datasets.

## 2. Target Outcomes
- Teach practical SQL concepts via progressive challenge design.
- Reinforce pattern recognition (joins, filtering, grouping, window functions, transactions, indexing concepts).
- Provide immediate, meaningful feedback (semantic hints, performance insights, schema reminders).
- Offer repeatable, scriptable content creation for new challenges.
- Allow future expansion to GUI or web front-end without rewriting core logic.

## 3. Primary Audience
- Self‑learners with some programming background (C++ familiarity) but limited SQL experience.
- Secondary: Developers wanting a type‑safe SQL DSL example (`sqlpp11`) in a gamified context.

## 4. Core Gameplay Loop
1. Present a Quest (scenario + dataset + learning goal).
2. Player inspects schema / sample rows.
3. Player writes a SQL query (or chooses to build via guided mode later).
4. System executes query safely in an isolated in‑memory (or temp file) DB.
5. Engine evaluates: correctness, result shape, edge conditions, performance heuristics.
6. Provide feedback + optional hints (tiered).
7. Award XP / badges / unlock next tier.

## 5. Game Modes (Planned)
| Mode | Description | Status |
|------|-------------|--------|
| Tutorial | Guided, partially filled queries | MVP Tier 1 |
| Challenge | Exact answer expected (deterministic) | MVP Tier 1 |
| Puzzle | Multiple valid answers, canonical scoring | Tier 2 |
| Speed Round | Timed query drafting | Tier 3 |
| Refactor | Optimize an existing inefficient query | Tier 3 |
| Sandbox | Freeform experimentation | Tier 2 |

## 6. Learning Objectives Roadmap (Progression Tiers)
1. Tier 1: SELECT, WHERE, ORDER BY, LIMIT
2. Tier 2: Aggregations, GROUP BY, HAVING
3. Tier 3: JOIN types (INNER, LEFT, self-joins)
4. Tier 4: Subqueries, EXISTS, IN
5. Tier 5: Set ops (UNION, INTERSECT), CASE expressions
6. Tier 6: Window functions (ROW_NUMBER, RANK, PARTITION BY)
7. Tier 7: CTEs & recursion
8. Tier 8: Transactions & ACID concepts (INSERT/UPDATE/DELETE scenarios)
9. Tier 9: Indexing concepts & query plans (informational) – stretch
10. Tier 10: Advanced patterns (pivoting, dynamic filtering) – stretch

## 7. Technology Stack (Initial)
- Language: C++23 with clang compiler
- Build System: CMake (modern targets, interface libs)
- SQL Layer: `sqlpp11` + backend connector (initially SQLite3)
- DB Engines (phased):
  - SQLite (embedded, easiest for portability)
  - PostgreSQL (optional advanced features later)
- Testing: GoogleTest
- Logging: spdlog
- Static Analysis: clang-tidy 
- Formatting: clang-format 

## 8. Why `sqlpp11`
- Type-safe composable SQL DSL reduces runtime errors.
- Encourages thinking in structured query building (reinforces concepts).
- Still allow raw SQL string submission path for learner authenticity—both paths supported.

## 9. Architectural Overview
Layered approach:
1. Core Domain: Quest definitions, scoring, skill progression, learning taxonomy.
2. Data Layer: DB session manager, schema seeding, dataset generation, execution adapters.
3. Evaluation Engine: Query comparator (expected vs actual), heuristic analysis (row count, ordering, duplicates, grouping correctness, column names), hint generator.
4. Interaction Layer (CLI initially): Input handling, pretty tables, colored feedback.
5. Extensibility / Plugin Layer: New quest packs, topic modules, connectors.
6. Support: Logging, config, persistence of progress.

## 10. Proposed Directory Structure
```
/sql_game
  /cmake/
  /third_party/
  /include/
    sql_game/
      core/            # Quest, Progression, PlayerProfile
      data/            # DBManager, DatasetFactory
      eval/            # QueryEvaluator, HintEngine
      ui/              # CLI Renderer, Input
      util/            # Logging, Formatting
  /src/
    core/
    data/
    eval/
    ui/
    util/
  /quests/
    basics/
      q_select_01.yaml
      q_where_02.yaml
    joins/
  /schemas/
  /datasets/
  /tests/
  CMakeLists.txt
  README.md
  HL_Context.md
```

## 11. Quest Definition Schema (Draft)
YAML example:
```yaml
id: select_basic_01
name: First Select
tier: 1
objective: Retrieve all columns for the first 5 customers.
learning_goals: [select, limit]
datasets:
  seed_schema: customers_basic.sql
  seed_logic: customers_basic_gen.lua # (optional future scripting)
expected:
  type: result_set
  sql: |
    SELECT id, name, email FROM customers ORDER BY id LIMIT 5;
constraints:
  must_select_columns: [id, name, email]
  ordering: required
hints:
  - Remember ORDER BY for deterministic row ordering.
  - LIMIT constrains row count.
scoring:
  base_xp: 50
  bonuses:
    first_try: 10
    no_hint: 5
```

## 12. Data & Execution Flow (Example)
1. Load quest YAML → parse domain object.
2. Ensure dataset seeded (idempotent) in ephemeral DB.
3. Accept learner query (raw string).
4. Run through safety checks (no DROP / destructive outside scope unless allowed).
5. Execute both learner and expected queries.
6. Compare: row count, column set, ordering, cell-wise diff.
7. If mismatch → generate dynamic hints (e.g., missing ORDER BY, extra columns, aggregation mismatch).
8. Record attempt (progress file / sqlite meta table).

## 13. Use of `sqlpp11`
Two parallel paths:
- Raw SQL path: Direct string -> execution.
- DSL path: (Optional) Provide pre-built skeleton or interactive builder to illustrate equivalent DSL.
Guidelines:
- Wrap backend selection behind an abstract `IDatabaseProvider` interface.
- Provide helper functions for common patterns (e.g., building WHERE predicates incrementally).

## 14. Modern C++ Guidelines
- Standard: Prefer C++23 features (if toolchain supports): `std::expected`, `std::string_view`, `std::ranges`, `constexpr`, `enum class`, `[[nodiscard]]`.
- Avoid raw owning pointers; use smart pointers or value types.
- Favor `span` / views over copying.
- Error Handling: Use `std::expected<T, Error>` for recoverable domain errors; use `std::optional<T>` for nullable values. **NO EXCEPTIONS** - design all APIs to be non-throwing.
- Use `constexpr` for static metadata (quest registry indices, etc.).
- Prefer `spdlog` for structured logging.

## 15. Error & Feedback Strategy
Error Categories:
- Parse errors (malformed SQL)
- Semantic mismatches (columns, ordering, aggregation)
- Performance warnings (SELECT *, unneeded DISTINCT) – later
- Safety violations (attempt to modify schema when not allowed)
All produce structured `EvaluationResult` object:
```cpp
struct EvaluationResult {
  bool correct;
  std::vector<Hint> hints;
  std::optional<DiffSummary> diff;
  ScoreDelta score;
};
```

## 16. Testing Strategy
- Unit: Quest parsing, dataset seeding idempotency, evaluator logic, hint generation.
- Integration: Full attempt cycle on sample quests.
- Golden tests: Expected query vs sample variations.
- Property tests (later): Randomized dataset generation invariants.

## 17. Performance Considerations
- Small datasets (hundreds to low thousands rows) to keep iteration fast.
- Use in-memory SQLite for speed, fallback to file when persistence needed.
- Cache parsed quests and compiled regex/pattern matchers.

## 18. Security / Safety
- Restrict allowed statements by mode (read-only early tiers).
- Potential static analysis of SQL string for blacklisted tokens.
- Escape output when rendering (future GUI/web).

## 19. Extensibility Guidelines
- New quest: Drop YAML file + dataset SQL + (optional) validation override.
- New topic tier: Add folder + index YAML describing ordering & dependencies.
- New DB backend: Implement `IDatabaseProvider` + config entry.

## 20. Persistence
- Player profile (JSON file) storing: completed quests, XP, hint usage, timestamps.
- Config file: chosen backend, difficulty, accessibility options.
- Simple JSON schema for easy debugging and manual editing if needed.

## 21. Logging
- Verbosity levels (error, info, debug) toggled via CLI flag.
- Provide structured logging adapter (future JSON mode for telemetry).

## 22. CLI Experience (MVP)
Commands (draft):
```
list quests
show quest <id>
play <id>
hint
submit
stats
quit
```

## 23. Milestone Roadmap
**M0: Bootstrap** (Project Foundation)
- CMake project scaffold with clang C++23 setup
- Dependency management (`sqlpp11`, `yaml-cpp`, `spdlog`, GoogleTest)
- Directory structure implementation
- Basic CI/build verification

**M1a: Domain Models** (Core Data Structures)
- `Quest` struct/class (data only)
- YAML quest loader with validation
- Basic error handling with `std::expected`
- Unit tests for quest parsing

**M1b: Database Foundation** (SQL Execution Layer)
- SQLite connection wrapper (`std::expected` based, no exceptions)
- Query execution engine (raw SQL path)
- Connection lifecycle management
- Integration tests for DB operations

**M1c: First Quest + Evaluator** (Core Game Logic)
- One simple SELECT quest implementation
- Basic result comparison (row count + column names)
- Query result evaluation logic
- End-to-end test workflow

**M1d: CLI + Second Quest** (User Interface)
- Simple command interface (`list`, `play`, `quit`)
- Second quest (SELECT with WHERE clause)
- Manual testing and user interaction
- Quest progression tracking

**M2: Enhanced Evaluation** (Smart Feedback)
- Column ordering validation
- Hint generation engine
- Detailed result comparison (cell-wise diff)
- Error categorization and messaging

**M3: sqlpp11 Integration** (Type-Safe SQL)
- Dual-path support (raw SQL + DSL)
- DSL example generation for quests
- Side-by-side comparison display
- Type safety demonstrations

**M4: Branching Progression** (Skill-Based Unlocking)
- Tier dependency system
- Skill-based quest unlocking
- Progress persistence (format TBD)
- XP and scoring system

**M5: Quest Content Expansion** (Learning Material)
- 8-10 additional quests (tiers 1-2)
- ORDER BY, LIMIT, basic functions
- Comprehensive test coverage
- Quest validation tooling

**M6: Advanced SQL Features** (Tier 3+)
- JOIN operations (INNER, LEFT)
- Subquery challenges
- Enhanced evaluator heuristics
- Performance hint system

**M7: Polish + Future Prep** (Production Ready)
- Logging integration throughout
- Error recovery mechanisms
- Future GUI abstraction layer (ImGui-compatible interfaces)
- Documentation and examples

**M8: Performance Analysis** (Final Milestone)
- Query plan inspection (`EXPLAIN`) implementation
- Performance hint system for optimization learning
- Advanced query analysis tools
- Educational content on query optimization

## 24. Agent Collaboration Guidelines
When the AI agent writes code:
- Maintain separation of concerns (no monolithic files > 500 LOC).
- Provide minimal, testable increments.
- Include/update tests alongside new features.
- If ambiguity arises: add TODO with concise question under `// TODO(agent-question):` and proceed with safe default.
- Never hardcode OS-specific paths.
- Use `std::expected` for domain operations returning failure states.

## 25. Style Conventions (Draft)
- Namespace root: `sql_game`.
- Filenames: `snake_case` for headers and sources.
- Header guards: `#pragma once`.
- Prefer forward declarations in headers where possible.
- One class/struct per header where practical.

## 26. Open Questions (To Clarify)
1. ✅ **ANSWERED:** C++23 with clang compiler
2. ✅ **ANSWERED:** GoogleTest for testing
3. ✅ **ANSWERED:** spdlog for logging
4. ✅ **ANSWERED:** Start with read-only queries (SELECT), add write operations (INSERT/UPDATE/DELETE) in later tiers
5. ✅ **ANSWERED:** Using open-source dependencies only (no licensing constraints)
6. ✅ **ANSWERED:** Skill-based branching progression (complete tier unlocks multiple parallel tracks)
7. ✅ **ANSWERED:** Start with 2 initial quests
8. ✅ **ANSWERED:** Option B - Integrate `sqlpp11` DSL alongside raw SQL from the beginning
9. ✅ **ANSWERED:** Error handling via `std::expected`/`std::optional`, no exceptions
10. ✅ **ANSWERED:** JSON file for player progress persistence
11. ✅ **ANSWERED:** ImGui target - design UI abstraction layer to support future ImGui integration
12. ✅ **ANSWERED:** Query plan inspection (`EXPLAIN`) - implement in final milestone for performance learning
13. ✅ **ANSWERED:** No time tracking for scoring/analytics

## 27. What To Provide Next (From You)
**ALL QUESTIONS ANSWERED:**
- ✅ C++ standard & compiler: C++23 with clang
- ✅ Test framework: GoogleTest
- ✅ Logging: spdlog
- ✅ Initial quest count: Start with 2 quests
- ✅ Dependencies: Open-source only
- ✅ Write operations: Read-only first, write operations in later tiers
- ✅ Progression: Skill-based branching (unlock parallel tracks)
- ✅ `sqlpp11` integration: Option B - from the beginning alongside raw SQL
- ✅ Error handling: `std::expected`/`std::optional`, no exceptions
- ✅ Persistence format: JSON file for player progress
- ✅ Future GUI considerations: Design UI abstraction layer for ImGui compatibility
- ✅ Query plan inspection: Implement `EXPLAIN` in final milestone for performance learning
- ✅ Time tracking: No time tracking for scoring/analytics

**PROJECT FULLY SPECIFIED - READY FOR IMPLEMENTATION**

## 28. Minimal Initial Implementation Slice (When Ready)
1. CMake project scaffold with clang + C++23.
2. Core domain types: `Quest`, `QuestRepository`.
3. YAML loader (using `yaml-cpp` - open source, widely used).
4. SQLite in-memory execution (raw SQL).
5. Two sample quests + evaluator comparing column set & row count.
6. Basic CLI to list & run quests.
7. GoogleTest setup with initial test cases.
8. spdlog integration for structured logging.

## 29. Deferred / Stretch Ideas
- Adaptive hint ML ranking.
- Web-based interactive playground.
- In-editor (VS Code extension) integration.
- Difficulty calibration via item response theory.
- Procedural dataset randomization per attempt.

## 30. Status Tag (Current)
**ALL SPECIFICATIONS COMPLETE – READY FOR IMPLEMENTATION**

**Next Action:** Begin M0 (Bootstrap) with CMake scaffold and dependency setup.

**Implementation Strategy:** Small, reviewable increments of 2-3 files per milestone sub-phase to enable thorough review and understanding before proceeding.

**Key Architectural Notes:**
- Design UI layer with abstract interfaces to support future ImGui integration
- JSON persistence for simplicity and debuggability
- Query plan analysis deferred to final milestone (M8)
- No time tracking to keep scoring system simple

---
## Quick Summary for Agent
Build a modular C++23 learning game: parse quest YAML → seed SQLite dataset → run user SQL → evaluate & hint → persist progress. Use modern patterns, clean architecture, type safety, incremental extensibility. Awaiting clarification on test framework, dependencies, and some design preferences before scaffolding.

---
## End of HL_Context
