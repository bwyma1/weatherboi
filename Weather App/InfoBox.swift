import SwiftUI

struct InfoBox: View {
    var type: String
    @State var currentValue: Double
    @State var maxValue: Double
    @State var maxTime: Date
    @State var minValue: Double
    @State var minTime: Date

    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        
        VStack(spacing: 8) {
            // Header
            Text(type)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
                .padding(.leading, 8)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            
            // Temp
            if(type == "Tempurature"){
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", currentValue))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("°F")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                }
            } else if (type == "DewPoint"){
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", currentValue))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("°F")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                }
            } else if (type == "Humidity"){
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", currentValue))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("%")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                }
            } else if (type == "Pressure"){
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.2f", currentValue))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("in")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                }
            } else if (type == "Wind Speed (Sustained)" || type == "Wind Speed (Gust)") {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", currentValue))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("mph")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                }
            } else if (type == "Rain") {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", currentValue))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("in")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                }
                HStack {
                    Text("Current Rate: " + String(format: "%.1f", maxValue))
                        .foregroundColor(.white)
                        .font(.body)
                }
            }

            
            // High / Low
            if(type == "Tempurature" || type == "DewPoint" || type == "Humidity" || type == "Pressure"){
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "arrow.up")
                            .foregroundColor(.white)
                        Text(String(format: "%.1f", maxValue))
                            .foregroundColor(.white)
                            .font(.body)
                        Spacer()
                        Text(timeFormatter.string(from: maxTime))
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    HStack {
                        Image(systemName: "arrow.down")
                            .foregroundColor(.white)
                        Text(String(format: "%.1f", minValue))
                            .foregroundColor(.white)
                            .font(.body)
                        Spacer()
                        Text(timeFormatter.string(from: minTime))
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                }
            } else if (type == "Wind Speed (Sustained)" || type == "Wind Speed (Gust)") {
                HStack {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.white)
                    Text(String(format: "%.1f", maxValue))
                        .foregroundColor(.white)
                        .font(.body)
                    Spacer()
                    Text(timeFormatter.string(from: maxTime))
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(8)
        .frame(width: 200, height: 130)
    }
}


