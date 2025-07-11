import SwiftUI
import Charts

struct RainPlot: View {
    @Bindable var appData: AppData
    
    var body: some View {
        Chart {
            ForEach(appData.filteredData) { entry in
                AreaMark(
                    x: .value("Date", entry.dateutc),
                    y: .value("Temp (°F)", entry.rainin),
                    series: .value("Series", "Rainfall")
                ).foregroundStyle(.blue).interpolationMethod(.catmullRom)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appData.filteredData)
        .chartYAxisLabel(position: .leading) {
            Text("Inches")
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel{
                    if let date = value.as(Date.self) {
                        let range = appData.endDate.timeIntervalSince(appData.startDate)
                        if range <= 60 * 60 * 24 { // less than or equal to 1 day
                            Text(date.formatted(date: .omitted, time: .shortened)) // Show time
                        } else {
                            Text(date.formatted(.dateTime.day().month(.abbreviated))) // Show date
                        }
                    }
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
        .padding()
    }
}
