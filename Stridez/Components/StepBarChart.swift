//
//  StepBarChart.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Charts
import SwiftUI

struct StepBarChart: View {
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

	var averageSteps: Int {
		Int(chartData.map { $0.value }.average)
	}

	var body: some View {
		ChartContainer(chartType: .stepBar(average: averageSteps)) {
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
								)
							}
						)
				}

				if !chartData.isEmpty {
					RuleMark(y: .value("Average", averageSteps))
						.foregroundStyle(Color.secondary)
						.lineStyle(.init(lineWidth: 1, dash: [5]))
				}

				ForEach(chartData) { steps in
					BarMark(
						x: .value("Date", steps.date, unit: .day),
						y: .value("Steps", steps.value)
					)
					.foregroundStyle(Color.pink.gradient)
					.opacity(rawSelectedDate == nil || steps.date == seletedHealthMetric?.date ? 1.0 : 0.3)
				}
			}
			.frame(height: 150)
			.chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
			.chartXAxis {
				AxisMarks {
					AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
				}
			}
			.chartYAxis {
				AxisMarks { value in
					AxisGridLine().foregroundStyle(Color.secondary.opacity(0.3))
					AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
				}
			}
			.overlay {
				if chartData.isEmpty {
					ChartEmptyView(
						systemImageName: "chart.bar",
						title: "No Data",
						description: "There is no step count data from the Health App."
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
	StepBarChart(selectedTab: HealthMetricContext.steps, chartData: [])
}
