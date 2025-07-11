//
//  Weather_AppTests.swift
//  Weather AppTests
//
//  Created by Brock Wyma on 7/9/25.
//

import Testing
@testable import Weather_App

struct Weather_AppTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func loadingData() async throws {
        let data = WeatherData.load(from: "weather_data")
        #expect(data != nil)
        #expect(data!.count == 10)
        print(data!)
    }

}
