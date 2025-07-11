//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by Brock Wyma on 7/9/25.
//

import SwiftUI

enum TimeFilter: String, CaseIterable, Identifiable {
    case day = "Last Day"
    case week = "Last Week"
    case all = "All"

    var id: String { self.rawValue }
}

// Global context class AppData
@Observable class AppData {
    let data = WeatherData.load(from: "weather_data") ?? []
    var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    var endDate: Date = Date()
    
    var filteredData: [WeatherData] {
        data.filter { $0.dateutc >= startDate && $0.dateutc <= endDate }
    }
}

@main
struct Weather_AppApp: App {
    
    // Creating a global context state object
    @State private var appData = AppData()
    
    // Menu state
    @State private var showMenu: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ScrollView{
                    VStack{
                        
                        // Horizontal Scroll for the Info Boxes
                        // Tempurature, DewPoint, Humidity, Pressure
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                InfoBox(type: "Tempurature", currentValue: 72.33, maxValue: 80.4, maxTime: Date(), minValue: 64.2, minTime: Date())
                                    .scrollTransition(.interactive()) {content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1:0)
                                    }
                                InfoBox(type: "DewPoint", currentValue: 72.33, maxValue: 80.4, maxTime: Date(), minValue: 64.1, minTime: Date())
                                    .scrollTransition(.interactive()) {content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1:0)
                                    }
                                InfoBox(type: "Humidity", currentValue: 72.33, maxValue: 80.4, maxTime: Date(), minValue: 64.1, minTime: Date())
                                    .scrollTransition(.interactive()) {content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1:0)
                                    }
                                InfoBox(type: "Pressure", currentValue: 72.33, maxValue: 80.4, maxTime: Date(), minValue: 64.1, minTime: Date())
                                    .scrollTransition(.interactive()) {content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1:0)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                        .scrollTargetBehavior(.viewAligned)
                        .scrollTransition(.interactive()) {content, phase in
                            content
                                .opacity(phase.isIdentity ? 1:0)
                        }
                        
                        // Horizontal Scroll for the Info Boxes
                        // Wind Speed (Sustained), Wind Speed (Gust), Rain
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                InfoBox(type: "Wind Speed (Sustained)", currentValue: 72.33, maxValue: 80.4, maxTime: Date(), minValue: 64.2, minTime: Date())
                                    .scrollTransition(.interactive()) {content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1:0)
                                    }
                                InfoBox(type: "Wind Speed (Gust)", currentValue: 72.33, maxValue: 80.4, maxTime: Date(), minValue: 64.1, minTime: Date())
                                    .scrollTransition(.interactive()) {content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1:0)
                                    }
                                InfoBox(type: "Rain", currentValue: 72.33, maxValue: 80.4, maxTime: Date(), minValue: 64.1, minTime: Date())
                                    .scrollTransition(.interactive()) {content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1:0)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                        .scrollTargetBehavior(.viewAligned)
                        .scrollTransition(.interactive()) {content, phase in
                            content
                                .opacity(phase.isIdentity ? 1:0)
                        }
                        
                        // Visual Plots for the weather data
                        // Time plot of tempurature, dewpoint, and humidity
                        TimePlot(appData: appData)
                        
                        // Radar visualization for the wind
                        WindRadar(appData: appData)
                        
                        // Area time plot for rainfall
                        RainPlot(appData: appData)
                    }
                    .environment(appData)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showMenu = true
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
                .sheet(isPresented: $showMenu) {
                    MenuView(appData: appData)
                        .environment(appData)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
