# Tasks: StudyMap

**Input**: Design documents from `.specify/memory/`

**Prerequisites**: plan.md (required), spec.md (required)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Initialize Flutter project structure and core dependencies in `pubspec.yaml`
- [x] T002 Configure Firebase project and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- [x] T003 Setup project-wide linting in `analysis_options.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Implement `FirebaseService` in `lib/core/services/firebase_service.dart`
- [x] T005 Setup `AppWidget` and main theme (Dark Mode) in `lib/app/app_widget.dart`
- [x] T006 Implement base `Repository` and `Entity` classes in `lib/core/domain/`
- [x] T007 [P] Configure `geolocator` and location permissions in Android/iOS manifests
- [x] T008 [P] Configure `flutter_local_notifications` initialization in `lib/core/notifications/`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Authentication (Priority: P1) 🎯 MVP

**Goal**: Allow users to login with Email/Password or Google to secure their study data.

**Independent Test**: Login successfully and see the user ID in the app state/controller.

### Implementation for User Story 1

- [x] T009 [P] [US1] Create `UserEntity` in `lib/features/auth/domain/user_entity.dart`
- [x] T010 [P] [US1] Define `AuthRepository` interface in `lib/features/auth/domain/auth_repository.dart`
- [x] T011 [US1] Implement `AuthRepositoryImpl` with Firebase Auth in `lib/features/auth/data/auth_repository_impl.dart`
- [x] T012 [US1] Create `AuthController` using Provider for state management in `lib/features/auth/presentation/auth_controller.dart`
- [x] T013 [US1] Implement Login Screen UI with Google and Email options in `lib/features/auth/presentation/login_screen.dart`

**Checkpoint**: Authentication is functional; subsequent features will use the authenticated user ID for Firestore paths.

---

## Phase 4: User Story 2 - Basic Data Management (Places & Subjects) (Priority: P2)

**Goal**: Allow users to manage their study locations and subjects (prerequisites for a session).

**Independent Test**: Create a new place and a new subject and verify they appear in their respective lists.

### Implementation for User Story 2

- [x] T014 [P] [US2] Create `PlaceEntity` and `SubjectEntity` in `lib/features/places/domain/place_entity.dart` and `lib/features/subjects/domain/subject_entity.dart`
- [x] T015 [US2] Implement Repositories for Places and Subjects in `lib/features/places/data/` and `lib/features/subjects/data/`
- [x] T016 [US2] Create controllers for Places and Subjects in their respective presentation layers
- [x] T017 [US2] Implement simple UI for adding and listing Places and Subjects to enable session selection

**Checkpoint**: Users can now define WHERE and WHAT they are studying.

---

## Phase 5: User Story 3 - Study Session Tracking (Priority: P1) 🎯 MVP CORE

**Goal**: Record study sessions with GPS location, duration, subject, and focus level.

**Independent Test**: Start a session, wait, stop it, fill the post-session modal, and verify it's saved in Firestore `sessions` subcollection.

### Implementation for User Story 3

- [x] T018 [P] [US3] Create `SessionEntity` in `lib/features/session/domain/session_entity.dart`
- [x] T019 [US3] Define `SessionRepository` interface and implementation in `lib/features/session/domain/session_repository.dart` and `lib/features/session/data/session_repository_impl.dart`
- [x] T020 [US3] Implement Location tracking logic to capture coordinates at session start in `lib/core/location/location_service.dart`
- [x] T021 [US3] Create `SessionController` to manage timer state and GPS capture in `lib/features/session/presentation/session_controller.dart`
- [x] T022 [US3] Implement Main Session screen with Start/Stop button and timer display in `lib/features/session/presentation/session_screen.dart`
- [x] T023 [US3] Implement Post-Session Modal for selecting Subject and Focus level (1-5) in `lib/features/session/presentation/post_session_modal.dart`

**Checkpoint**: The core value proposition (tracking study sessions by location) is now functional.

---

## Phase 6: User Story 4 - Dashboard & Statistics (Priority: P2)

**Goal**: Visualize productivity rankings and charts by location.

**Independent Test**: Access the dashboard and see a bar chart showing productivity indices grouped by location.

### Implementation for User Story 4

- [x] T024 [P] [US4] Implement Productivity calculation logic (Foco x Duração) in `lib/features/stats/domain/productivity_calculator.dart`
- [x] T025 [US4] Create `StatsController` to aggregate and group session data from Firestore in `lib/features/stats/presentation/stats_controller.dart`
- [x] T026 [US4] Implement Productivity Chart using `fl_chart` in `lib/features/stats/presentation/widgets/productivity_chart.dart`
- [x] T027 [US4] Implement Dashboard screen showing the ranking of best study locations in `lib/features/stats/presentation/dashboard_screen.dart`

**Checkpoint**: Users can now gain insights from their recorded study sessions.

---

## Phase 7: User Story 5 - Profile & Shell Navigation (Priority: P3)

**Goal**: Finalize the app shell with bottom navigation and profile management.

**Independent Test**: Navigate between Session, Dashboard, and Profile using the bottom navigation bar.

### Implementation for User Story 5

- [x] T028 [US5] Implement `MainNavigationShell` with `BottomNavigationBar` in `lib/features/main/presentation/main_shell.dart`
- [x] T029 [US5] Implement Profile Screen showing user info and Logout option in `lib/features/profile/presentation/profile_screen.dart`

**Checkpoint**: App navigation is complete and intuitive.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Aesthetic refinements and overall stability

- [x] T030 Implement global styles (Glassmorphism, Bento-box grids) per Design System in `lib/core/utils/theme_utils.dart`
- [x] T031 Add loading indicators and consistent error handling across all controllers
- [x] T032 Optimize Firestore queries with appropriate indexes (if needed)
- [x] T033 Run final manual validation of the full "Study Session" user journey

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Completed.
- **Foundational (Phase 2)**: Completed.
- **User Stories (Phase 3+)**: All core user stories implemented and integrated.
- **Polish (Final Phase)**: Completed.

### Parallel Opportunities

- T007 (Location Config) and T008 (Notifications Config) in Phase 2.
- T009 (User Entity) and T010 (Auth Interface) in Phase 3.
- T014 (Entities) for Places and Subjects in Phase 4.
- Once Authentication (US1) is complete, basic UI/Controller work for US2 and US4 could technically start in parallel if needed, though they are logically sequential.

---

## Parallel Example: Setup & Foundation

```bash
# Configure platforms in parallel:
Task: "Configure geolocator and location permissions in Android/iOS manifests"
Task: "Configure flutter_local_notifications initialization in lib/core/notifications/"
```

---

## Implementation Strategy

### MVP First (Authentication + Session)

1. Complete Setup and Foundational phases.
2. Complete User Story 1 (Authentication).
3. Complete User Story 2 (Basic Data - Places/Subjects).
4. Complete User Story 3 (Session Tracking).
5. **STOP and VALIDATE**: Verify that a user can login, start a session, and save it with a location and subject.

### Incremental Delivery

1. Foundation ready.
2. MVP functional (Auth + Session).
3. Add Dashboard (US4) for data visualization.
4. Add Profile and Navigation Shell (US5) for final polish.
5. Apply Design System styles (Phase 8).

---

## Notes

- [P] tasks = different files, no dependencies within the same phase.
- [Story] label maps task to specific user story for traceability.
- Each user story is designed to be independently testable once its prerequisites are met.
