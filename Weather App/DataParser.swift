//
//  Data.swift
//  Weather App
//
import Foundation

struct WeatherData: Identifiable, Decodable, Equatable {
    let dateutc: Date
    let tempf: Double
    let humidity: Double
    let dewPointf: Double
    let pressure: Double
    let windChillf: Double
    let windSpeed: Double
    let windDirection: Int
    let rainin: Double
    let uv: Int
    
    // Adding Identifiability
    var id: Date { dateutc }
    
    enum CodingKeys: String, CodingKey{
        case dateutc = "dateutc"
        case tempf = "tempf"
        case humidity = "humidity"
        case dewPointf = "dewptf"
        case pressure = "pressure"
        case windChillf = "windchillf"
        case windSpeed = "windspeedmph"
        case windDirection = "winddir"
        case rainin = "rainin"
        case uv = "UV"
    }
    
    static func load(from filename: String) -> [WeatherData]? {
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)

            // Try to load the file from the app bundle (for iOS/macOS)
            guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                print("File not found: \(filename).json")
                return nil
            }

            do {
                let data = try Data(contentsOf: url)
                let weatherData = try decoder.decode([WeatherData].self, from: data)
                return weatherData
            } catch {
                print("Failed to decode JSON: \(error)")
                return nil
            }
        }
}

