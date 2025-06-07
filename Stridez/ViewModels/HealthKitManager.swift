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
}
