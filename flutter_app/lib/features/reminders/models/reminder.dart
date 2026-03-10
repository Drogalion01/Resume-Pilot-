// Freezed + json_serializable model for a reminder.
//
// Verified against backend/app/schemas/reminder.py.
//
// ⚠ Reminders are ALWAYS scoped to an application in this backend.
//    There is no standalone global reminder (no user-level reminders table).
//    There is NO GET /reminders list endpoint.
//    Reminder lists are loaded from ApplicationDetailResponse.reminders.
//
// ─── ReminderResponse ────────────────────────────────────────────────────────
//   id              int
//   application_id  int
//   title           String
//   scheduled_for   DateTime?  — ISO8601 datetime, nullable
//   completed       bool
//   is_enabled      bool       — soft toggle (does NOT delete the reminder)
//   created_at      DateTime
//   updated_at      DateTime
//
// ─── ReminderCreate (POST /applications/{id}/reminders body) ─────────────────
//   title, scheduled_for?, completed?, is_enabled?
//   NOTE: application_id comes from the URL path, not the body.
//
// ─── ReminderUpdate (PATCH /reminders/{id} body) ─────────────────────────────
//   All fields optional: title?, scheduled_for?, completed?, is_enabled?
//
// Used only within ApplicationDetailScreen — not in a standalone reminders tab.
