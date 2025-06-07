//
//  HealthKitManager.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
	let store = HKHealthStore()
	let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]

//	func addSimulatorData() async {
//		var mockSamples: [HKQuantitySample] = []
//
//		for i in 0 ..< 20 {
//			let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000 ... 10_000))
//			let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: 160 + Double(i/3) ... 165 + Double(i/3)))
//
//			let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
//			let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
//
//			let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
//			let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
//
//			mockSamples.append(stepSample)
//			mockSamples.append(weightSample)
//		}
//
//		try! await store.save(mockSamples)
//	}
}
