import SwiftUI
import Charts

struct TimePlot: View {
    @State private var zoomScale: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    
    @Bindable var appData: AppData
    
    private func calculateXAxisDomain() -> ClosedRange<Date> {

        let initialStartDate = appData.filteredData.first?.dateutc ?? Date()
        let initialEndDate = appData.filteredData.last?.dateutc ?? Date()

        let timeInterval = initialEndDate.timeIntervalSince(initialStartDate)
        let scaledInterval = timeInterval / Double(zoomScale)

        let newStartDate = initialStartDate.addingTimeInterval(scaledInterval * -Double(panOffset.width / 100))
        let newEndDate = newStartDate.addingTimeInterval(scaledInterval)
        
        return newStartDate...newEndDate
    }

    private func calculateYAxisDomain() -> ClosedRange<Double> {
        
        let minValue = min(
            appData.filteredData.map(\.tempf).min() ?? .infinity,
            appData.filteredData.map(\.dewPointf).min() ?? .infinity,
            appData.filteredData.map(\.humidity).min() ?? .infinity
        )

        let maxValue = max(
            appData.filteredData.map(\.tempf).max() ?? -.infinity,
            appData.filteredData.map(\.dewPointf).max() ?? -.infinity,
            appData.filteredData.map(\.humidity).max() ?? -.infinity
        )

        // Safety fallback
        guard minValue.isFinite, maxValue.isFinite else {
            return 0...100
        }

        let scaledMin = minValue / Double(zoomScale)
        let scaledMax = maxValue * Double(zoomScale)

        return scaledMin...scaledMax
    }
    
    var body: some View {
        Chart {
            ForEach(appData.filteredData) { entry in
                LineMark(
                    x: .value("Date", entry.dateutc),
                    y: .value("Temp (°F)", entry.tempf),
                    series: .value("Series", "Temperature")
                ).foregroundStyle(.red).interpolationMethod(.catmullRom)
            
                LineMark(
                    x: .value("Date", entry.dateutc),
                    y: .value("Dew Point (°F)", entry.dewPointf),
                    series: .value("Series", "Dew Point")
                ).foregroundStyle(.blue).interpolationMethod(.catmullRom)
                
                LineMark(
                    x: .value("Date", entry.dateutc),
                    y: .value("Humidity (%)", entry.humidity),
                    series: .value("Series", "Humidity")
                ).foregroundStyle(.green).interpolationMethod(.catmullRom)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appData.filteredData)
        .chartYAxisLabel(position: .leading) {
            Text("Value")
        }
        .chartForegroundStyleScale(["Tempurature": Color.red, "Dew Point": Color.blue, "Humidity": Color.green])
        .chartLegend(position: .bottom)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel{
                    if let date = value.as(Date.self) {
                        let range = appData.endDate.timeIntervalSince(appData.startDate)
                        if range <= 60 * 60 * 24 {
                            Text(date.formatted(date: .omitted, time: .shortened))
                        } else {
                            Text(date.formatted(.dateTime.day().month(.abbreviated)))
                        }
                    }

                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
        .padding()
        .chartXScale(domain: calculateXAxisDomain())
        .chartYScale(domain: calculateYAxisDomain()) // Optionally apply to Y-axis too
        .gesture(
            MagnificationGesture()
                .onChanged { newScale in
                    zoomScale = newScale
                }
                .onEnded { _ in
                    // You might want to update the actual date range here
                    // based on the final zoomScale for persistence or other actions
                }
        )
        .gesture(
            DragGesture()
                .onChanged { drag in
                    panOffset = drag.translation
                }
                .onEnded { _ in
                    // Update the date range based on the final panOffset
                    // and reset panOffset for next drag
                    panOffset = .zero
                }
        )
    }
}

