//
//  ChartMath.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Algorithms
import Foundation

enum ChartMath {
	static func averageWeekdayCount(for metric: [HealthMetric]) -> [WeekdayChartData] {
		let sortedByWeekday = metric.sorted(using: KeyPathComparator(\.date.weekdayInt))
		let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
		var weekdayChartData: [WeekdayChartData] = []

		for array in weekdayArray {
			guard let firstValue = array.first else { continue }
			let total = array.reduce(0) { $0 + $1.value }
			let avgSteps = total / Double(array.count)
			weekdayChartData.append(.init(date: firstValue.date, value: avgSteps))
		}

		return weekdayChartData
	}

	static func averageDailyWeightDiffs(for weights: [HealthMetric]) -> [DailyWeightData] {
		var diffValues: [(date: Date, value: Double)] = []

		guard weights.count > 1 else { return [] }

		for i in 1 ..< weights.count {
			let date = weights[i].date
			let diff = weights[i].value - weights[i - 1].value
			diffValues.append((date: date, value: diff))
		}

		let sortedByWeekday = diffValues.sorted(using: KeyPathComparator(\.date.weekdayInt))
		let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
		var weekdayChartData: [DailyWeightData] = []

		for array in weekdayArray {
			guard let firstValue = array.first else { continue }
			let total = array.reduce(0) { $0 + $1.value }
			let avgWeightDiff = total / Double(array.count)
			weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
		}

		return weekdayChartData
	}
}
