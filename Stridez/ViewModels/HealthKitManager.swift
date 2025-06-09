//
//  HealthKitManager.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import Foundation
import HealthKit
import Observation

@Observable
@MainActor
final class HealthKitData: Sendable {
	var stepData: [HealthMetric] = []
	var weightData: [HealthMetric] = []
	var weightDiffData: [HealthMetric] = []
}

@Observable
final class HealthKitManager: Sendable {
	let store = HKHealthStore()
	let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]

	/// Create a DateInterval between two dates
	/// - Parameters:
	///   - date: End of date interval. Ex - today
	///   - daysBack: Start of date interval. Ex - 28 days ago
	/// - Returns: Date range between two dates as a DateInterval
	private func createDateInterval(from date: Date, daysBack: Int) -> DateInterval {
		let calendar = Calendar.current
		let startOfEndDate = calendar.startOfDay(for: date)
		let endDate = calendar.date(byAdding: .day, value: 1, to: startOfEndDate)!
		let startDate = calendar.date(byAdding: .day, value: -daysBack, to: endDate)!

		return DateInterval(start: startDate, end: endDate)
	}

	/// Fetch last 28 days of step count from HealthKit.
	/// - Returns: Array of  ``HealthMetric``
	func fetchStepCount() async throws -> [HealthMetric] {
		guard store.authorizationStatus(for: HKQuantityType(.stepCount)) != .notDetermined else {
			throw CustomError.authNotDetermined
		}

		let interval = createDateInterval(from: .now, daysBack: 28)
		let queryPredicate = HKQuery.predicateForSamples(withStart: interval.start, end: interval.end)
		let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
		let stepsQuery = HKStatisticsCollectionQueryDescriptor(
			predicate: samplePredicate,
			options: .cumulativeSum,
			anchorDate: interval.end,
			intervalComponents: .init(day: 1)
		)

		do {
			let stepCounts = try await stepsQuery.result(for: store)
			return stepCounts.statistics().map {
				.init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
			}
		} catch HKError.errorNoData {
			throw CustomError.noData
		} catch {
			throw CustomError.unableToCompleteRequest
		}
	}

	/// Fetch most recent weight sample on each for a specified number of days back from today.
	/// - Parameter daysBack: Days back from today. Ex - 28 will return the last 28 days.
	/// - Returns: Array of ``HealthMetric``
	func fetchWeights(daysBack: Int) async throws -> [HealthMetric] {
		guard store.authorizationStatus(for: HKQuantityType(.bodyMass)) != .notDetermined else {
			throw CustomError.authNotDetermined
		}

		let interval = createDateInterval(from: .now, daysBack: daysBack)
		let queryPredicate = HKQuery.predicateForSamples(withStart: interval.start, end: interval.end)
		let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
		let weightQuery = HKStatisticsCollectionQueryDescriptor(
			predicate: samplePredicate,
			options: .mostRecent,
			anchorDate: interval.end,
			intervalComponents: .init(day: 1)
		)

		do {
			let weights = try await weightQuery.result(for: store)
			return weights.statistics().map {
				.init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
			}
		} catch HKError.errorNoData {
			throw CustomError.noData
		} catch {
			throw CustomError.unableToCompleteRequest
		}
	}

	/// Write step count data to HealthKit. Requires HealthKit write permission.
	/// - Parameters:
	///   - date: Date for step count value
	///   - value: Step count value
	func addStepData(for date: Date, value: Double) async throws {
		let status = store.authorizationStatus(for: HKQuantityType(.stepCount))
		switch status {
			case .notDetermined:
				throw CustomError.authNotDetermined
			case .sharingDenied:
				throw CustomError.sharingDenied(quantityType: "step count")
			case .sharingAuthorized:
				break
			@unknown default:
				break
		}

		let stepQuantity = HKQuantity(unit: .count(), doubleValue: value)
		let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: date, end: date)
		do {
			try await store.save(stepSample)
		} catch {
			throw CustomError.unableToCompleteRequest
		}
	}

	/// Write weight value to HealthKit. Requires HealthKit write permission.
	/// - Parameters:
	///   - date: Date for weight value
	///   - value: Weight value in pounds. Uses pounds as Double for .bodyMass conversions.
	func addWeightData(for date: Date, value: Double) async throws {
		let status = store.authorizationStatus(for: HKQuantityType(.bodyMass))
		switch status {
			case .notDetermined:
				throw CustomError.authNotDetermined
			case .sharingDenied:
				throw CustomError.sharingDenied(quantityType: "weight")
			case .sharingAuthorized:
				break
			@unknown default:
				break
		}

		let weightQuanity = HKQuantity(unit: .pound(), doubleValue: value)
		let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuanity, start: date, end: date)
		do {
			try await store.save(weightSample)
		} catch {
			throw CustomError.unableToCompleteRequest
		}
	}

//	func addSimulatorData() async {
//		var mockSamples: [HKQuantitySample] = []
//
//		for i in 0 ..< 28 {
//			let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
//			let weightQuanity = HKQuantity(unit: .pound(), doubleValue: .random(in: 160 + Double(i/3)...165 + Double(i/3)))
//
//			let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
//			let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate)!
//
//			let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
//			let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuanity, start: startDate, end: endDate)
//
//			mockSamples.append(stepSample)
//			mockSamples.append(weightSample)
//		}
//
//		try! await store.save(mockSamples)
//		print("✅ Dummy Data sent up")
//	}
}
