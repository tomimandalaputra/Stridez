//
//  HealthMetric.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import Foundation

struct HealthMetric: Identifiable {
	let id = UUID()
	let date: Date
	let value: Double
}
