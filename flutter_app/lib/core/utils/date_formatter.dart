// Date and time formatting utilities for display throughout the app.
//
// All methods use the intl package for locale-aware formatting.
//
// Methods:
//   formatDate(DateTime)           → "Mar 10, 2026"   (application dates, resume upload)
//   formatDateShort(DateTime)      → "Mar 10"          (compact list views)
//   formatDateRelative(DateTime)   → "2 days ago"      (dashboard activity feed)
//   formatTime(DateTime)           → "2:30 PM"         (interview scheduled time)
//   formatDateTime(DateTime)       → "Mar 10, 2026 at 2:30 PM"  (interview detail)
//   formatMonthYear(DateTime)      → "March 2026"      (grouping headers)
//
// Input always accepts DateTime (UTC from server); display converts to local time.
// No dates are formatted directly in widgets — always call through here.
