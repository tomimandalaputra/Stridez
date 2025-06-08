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

	var selectedTab: HealthMetricContext
	var chartData: [HealthMetric]

	var avgStepCount: Double {
		guard !chartData.isEmpty else {
			return 0
		}

		let totalSteps = chartData.reduce(0) { $0 + $1.value }
		return totalSteps / Double(chartData.count)
	}

	var seletedHealthMetric: HealthMetric? {
		guard let rawSelectedDate else { return nil }
		return chartData.first {
			Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
		}
	}

	var body: some View {
		VStack {
			NavigationLink(value: selectedTab) {
				HStack {
					VStack(alignment: .leading) {
						Label("Steps", systemImage: "figure.walk")
							.font(.title3.bold())
							.foregroundStyle(.pink)

						Text("Avg: \(Int(avgStepCount)) steps")
							.font(.caption)
					}

					Spacer()

					Image(systemName: "chevron.right")
				}
			}
			.foregroundStyle(.secondary)
			.padding(.bottom, 12)

			Chart {
				ForEach(chartData) { steps in
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
										seletedValue: seletedHealthMetric.value
									)
								}
							)
					}

					RuleMark(y: .value("Average", avgStepCount))
						.foregroundStyle(Color.secondary)
						.lineStyle(.init(lineWidth: 1, dash: [5]))

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
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}
}

#Preview {
	StepBarChart(selectedTab: HealthMetricContext.steps, chartData: MockData.steps)
}
