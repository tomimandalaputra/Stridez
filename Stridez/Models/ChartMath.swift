//
//  ChartMath.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Algorithms
import Foundation

struct ChartMath {
	static func averageWeekDayCount(for metric: [HealthMetric]) -> [WeekdayChartData] {
		let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
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
}
