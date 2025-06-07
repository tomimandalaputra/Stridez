//
//  StridezApp.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

@main
struct StridezApp: App {
	let hkManager = HealthKitManager()

	var body: some Scene {
		WindowGroup {
			DashboardView()
				.environment(hkManager)
		}
	}
}
