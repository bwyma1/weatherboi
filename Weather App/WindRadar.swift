import SwiftUI
import Charts
import Foundation

struct WindPoint: Identifiable {
    let id = UUID()
    let angle: Double        // windDirection in degrees
    let distance: Double     // windSpeed
    let chill: Double        // windChillF
}


func polarToXY(angle: Double, radius: Double, maxRadius: Double, size: CGSize) -> CGPoint {
    let angleRad = angle * .pi / 180
    let scaledRadius = (radius / maxRadius) * min(size.width, size.height) / 2
    let x = size.width / 2 + CGFloat(cos(angleRad)) * CGFloat(scaledRadius)
    let y = size.height / 2 - CGFloat(sin(angleRad)) * CGFloat(scaledRadius)
    return CGPoint(x: x, y: y)
}


struct WindRadar: View {
    @Bindable var appData: AppData
    
    var windPoints: [WindPoint] {
        appData.filteredData.map {
            WindPoint(angle: Double($0.windDirection),
                      distance: $0.windSpeed,
                      chill: $0.windChillf)
        }
    }

    var maxSpeed: Double {
        windPoints.map(\.distance).max() ?? 1
    }

    var minChill: Double {
        windPoints.map(\.chill).min() ?? 0
    }

    var maxChill: Double {
        windPoints.map(\.chill).max() ?? 1
    }

    func color(for chill: Double) -> Color {
        let fraction = (chill - minChill) / (maxChill - minChill)
        return Color(hue: 0.6, saturation: 1, brightness: 1 - fraction * 0.4) 
    }

    let directions = [
        ("N", 270.0),
        ("NE", 315.0),
        ("E", 0.0),
        ("SE", 45.0),
        ("S", 90.0),
        ("SW", 135.0),
        ("W", 180.0),
        ("NW", 225.0)
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                let labelRadius = geo.size.width / 2 + 15

                

                // Grid Rings
                ForEach(1..<5) { i in
                    let radiusFraction = CGFloat(i) / 4
                    let ringRadius = (geo.size.width / 2) * radiusFraction
                    let speedValue = maxSpeed * Double(radiusFraction)

                    // Draw ring
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .frame(width: ringRadius * 2, height: ringRadius * 2)
                        .position(center)

                    // Label the ring (on the right edge)
                    Text("\(Int(speedValue.rounded())) mph")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .position(x: center.x,
                                  y: center.y - ringRadius + 15)
                }
                // Wind points
                ForEach(windPoints) { point in
                    let xy = polarToXY(angle: point.angle,
                                       radius: point.distance,
                                       maxRadius: maxSpeed,
                                       size: geo.size)
                    Circle()
                        .fill(color(for: point.chill))
                        .frame(width: 10, height: 10)
                        .position(xy)
                        .shadow(radius: 2)
                }

                // Center dot
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 6, height: 6)
                    .position(center)
                
                // Compass Labels
                ForEach(directions, id: \.0) { label, angle in
                    let angleRad = angle * .pi / 180
                    let x = center.x + cos(angleRad) * labelRadius
                    let y = center.y + sin(angleRad) * labelRadius

                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .position(x: x, y: y)
                        .bold()
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appData.filteredData)
        .aspectRatio(1, contentMode: .fit)
        .padding(30)
        .background(.thinMaterial)
        .clipShape(Circle())
    }
}

