//
//  WeightLineChart.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Charts
import SwiftUI

struct WeightLineChart: View {
	@State private var rawSelectedDate: Date?
	@State private var selectedDay: Date?

	var selectedTab: HealthMetricContext
	var chartData: [HealthMetric]

	var seletedHealthMetric: HealthMetric? {
		guard let rawSelectedDate else { return nil }
		return chartData.first {
			Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
		}
	}

	var minValue: Double {
		chartData.map { $0.value }.min() ?? 0
	}

	var subtitle: String {
		let average = chartData.map { $0.value }.average
		return "Avg: \(average.formatted(.number.precision(.fractionLength(1)))) lbs"
	}

	var body: some View {
		ChartContainer(
			title: "Weight",
			symbol: "figure",
			subtitle: subtitle,
			context: selectedTab,
			isNav: true
		) {
			Chart {
				if let seletedHealthMetric {
					RuleMark(x: .value("Selected Metric", seletedHealthMetric.date, unit: .day))
						.foregroundStyle(Color.secondary.opacity(0.3))
						.offset(y: -10)
						.annotation(
							position: .top,
							alignment: .center,
							spacing: 0,
							overflowResolution: .init(x: .fit(to: .chart), y: .disabled),
							content: {
								AnnotationView(
									seletedDate: seletedHealthMetric.date,
									seletedValue: seletedHealthMetric.value,
									fractionLenghtValue: 1,
									styleTextColor: .indigo
								)
							}
						)
				}

				if !chartData.isEmpty {
					RuleMark(y: .value("Goal", 138))
						.foregroundStyle(Color.mint)
						.lineStyle(.init(lineWidth: 1, dash: [5]))
						.annotation(alignment: .leading) {
							Text("Goal")
								.font(.caption)
								.foregroundStyle(Color.secondary)
						}
				}

				ForEach(chartData) { weights in
					AreaMark(
						x: .value("Day", weights.date, unit: .day),
						yStart: .value("Value", weights.value),
						yEnd: .value("Min Value", minValue)
					)
					.foregroundStyle(Gradient(colors: [.indigo.opacity(0.5), .clear]))
					.interpolationMethod(.catmullRom)

					LineMark(
						x: .value("Day", weights.date, unit: .day),
						y: .value("Value", weights.value)
					)
					.foregroundStyle(Color.indigo)
					.interpolationMethod(.catmullRom)
					.symbol(.circle)
				}
			}
			.frame(height: 150)
			.chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
			.chartYScale(domain: .automatic(includesZero: false))
			.chartXAxis {
				AxisMarks {
					AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
				}
			}
			.chartYAxis {
				AxisMarks { _ in
					AxisGridLine().foregroundStyle(Color.secondary.opacity(0.3))
					AxisValueLabel()
				}
			}.overlay {
				if chartData.isEmpty {
					ChartEmptyView(
						systemImageName: "chart.xyaxis.line",
						title: "No Data",
						description: "There is no weight data from the Health App."
					)
				}
			}
		}
		.sensoryFeedback(.selection, trigger: selectedDay)
		.onChange(of: rawSelectedDate) { oldValue, newValue in
			guard let oldValue, let newValue else { return }
			if oldValue.weekdayInt != newValue.weekdayInt {
				selectedDay = newValue
			}
		}
	}
}

#Preview {
	WeightLineChart(selectedTab: .weight, chartData: [])
}
