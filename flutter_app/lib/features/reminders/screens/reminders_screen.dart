// Reminders screen (/reminders) — accessible from Dashboard quick actions.
//
// Layout:
//   ScreenHeader: "Reminders" + add icon button
//   Section "Overdue" (shown only if any exist, amber warning header):
//     ListItems with red accent — each has title, overdue date, complete/delete actions
//   Section "Upcoming":
//     ListItems sorted by due date — date chip, title, complete/delete actions
//   Section "Completed" (collapsible, gray):
//     ListItems with strikethrough text
//   Empty state: "No reminders set — add one to stay on track"
//
// FAB: "Add Reminder" opens an AddReminderBottomSheet (modal bottom sheet)
//   Form: title (required), due date (DatePicker), description, link to application
//
// ConsumerWidget.
