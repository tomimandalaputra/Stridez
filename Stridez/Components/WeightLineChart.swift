//
//  WeightLineChart.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Charts
import SwiftUI

struct WeightLineChart: View {
	var selectedTab: HealthMetricContext
	var chartData: [HealthMetric]

	var minValue: Double {
		chartData.map { $0.value }.min() ?? 0
	}

	var body: some View {
		VStack {
			NavigationLink(value: selectedTab) {
				HStack {
					VStack(alignment: .leading) {
						Label("Weight", systemImage: "figure")
							.font(.title3.bold())
							.foregroundStyle(Color.indigo)

						Text("Avg: 180 lbs")
							.font(.caption)
					}

					Spacer()

					Image(systemName: "chevron.right")
				}
			}
			.foregroundStyle(.secondary)
			.padding(.bottom, 12)

			Chart {
				RuleMark(y: .value("Goal", 155))
					.foregroundStyle(Color.mint)
					.lineStyle(.init(lineWidth: 1, dash: [5]))
					.annotation(alignment: .leading) {
						Text("Goal")
							.font(.caption)
							.foregroundStyle(Color.secondary)
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
			}
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}
}

#Preview {
	WeightLineChart(selectedTab: .weight, chartData: MockData.weights)
}
