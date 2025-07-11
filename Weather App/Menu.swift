import SwiftUI

struct MenuView: View {
    @Bindable var appData: AppData
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Range")) {
                    DatePicker("Start Date", selection: $appData.startDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.automatic)
                    DatePicker("End Date", selection: $appData.endDate, in: appData.startDate..., displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.automatic)
                }
            }
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
        }
    }
}

#Preview {
    MenuView(appData: AppData())
}
