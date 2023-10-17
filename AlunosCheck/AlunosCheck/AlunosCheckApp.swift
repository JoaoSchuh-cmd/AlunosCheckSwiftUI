//
//  AlunosCheckApp.swift
//  AlunosCheck
//
//  Created by user241342 on 10/7/23.
//

import SwiftUI

@main
struct AlunosCheckApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
