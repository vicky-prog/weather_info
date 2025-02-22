//
//  weather_infoApp.swift
//  Shared
//
//  Created by vignesh on 22/02/25.
//

import SwiftUI

@main
struct weather_infoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
