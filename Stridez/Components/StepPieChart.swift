//
//  StepPieChart.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Charts
import SwiftUI

struct StepPieChart: View {
	@State private var rawSelectedChartValue: Double? = 0

	var selectedWeekday: WeekdayChartData? {
		guard let rawSelectedChartValue else { return nil }
		var total = 0.0
		return chartData.first {
			total += $0.value
			return rawSelectedChartValue <= total
		}
	}

	var chartData: [WeekdayChartData]

	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Label("Averages", systemImage: "calendar")
					.font(.title3.bold())
					.foregroundStyle(.pink)

				Text("Last 28 Days")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			.padding(.bottom, 12)

			Chart {
				ForEach(chartData) { weekday in
					SectorMark(
						angle: .value("Average Steps", weekday.value),
						innerRadius: .ratio(0.618),
						outerRadius: selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 140 : 110,
						angularInset: 1
					)
					.foregroundStyle(Color.pink.gradient)
					.cornerRadius(8)
					.opacity(selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 1.0 : 0.3)
				}
			}
			.frame(height: 240)
			.chartAngleSelection(value: $rawSelectedChartValue.animation(.easeOut))
			.chartBackground { proxy in
				GeometryReader { geo in
					if let plotFrame = proxy.plotFrame,
					   let selectedWeekday
					{
						let frame = geo[plotFrame]
						VStack {
							Text(selectedWeekday.date.weekdayTitle)
								.font(.title3.bold())
								.contentTransition(.identity)

							Text(selectedWeekday.value, format: .number.precision(.fractionLength(0)))
								.fontWeight(.medium)
								.foregroundStyle(.secondary)
								.contentTransition(.numericText())
						}
						.position(x: frame.midX, y: frame.midY)
					}
				}
			}
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}
}

#Preview {
	StepPieChart(chartData: ChartMath.averageWeekDayCount(for: MockData.steps))
}
