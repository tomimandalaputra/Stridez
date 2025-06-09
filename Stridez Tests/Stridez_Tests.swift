//
//  Stridez_Tests.swift
//  Stridez Tests
//
//  Created by tukucode on 09/06/25.
//

import Foundation
@testable import Stridez
import Testing

struct Stridez_Tests {
	@Test func arrayAverage() {
		// Example data
		let array: [Double] = [1.0, 3.1, 0.4, 2.5, 0.86]
		#expect(array.average == 1.572)
	}
}

@Suite("Chart helper Test") struct ChartHelperTests {
	var metrics: [HealthMetric] = [
		.init(date: Calendar.current.date(from: .init(year: 2025, month: 6, day: 1))!, value: 1000), // Sunday
		.init(date: Calendar.current.date(from: .init(year: 2025, month: 6, day: 2))!, value: 950), // Monday
		.init(date: Calendar.current.date(from: .init(year: 2025, month: 6, day: 3))!, value: 1200), // Tuesday
		.init(date: Calendar.current.date(from: .init(year: 2025, month: 6, day: 4))!, value: 1122) // Wednesday
	]

	@Test func averageWeekdayCount() {
		let avgWeekdayCount = ChartMath.averageWeekdayCount(for: metrics)
		#expect(avgWeekdayCount.count == 4)
		#expect(avgWeekdayCount[2].value == 1200)
		#expect(avgWeekdayCount[3].date.weekdayTitle == "Wednesday")
	}
}
