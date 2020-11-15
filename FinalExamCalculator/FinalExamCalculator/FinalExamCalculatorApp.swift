//
//  FinalExamCalculatorApp.swift
//  FinalExamCalculator
//
//  Created by Austin Blaser on 11/14/20.
//

import SwiftUI

@main
struct FinalExamCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                CoreDataStack.shared.initializeCoreData { (result) in
                    switch result {
                    case .success:
                        print("Success")
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
