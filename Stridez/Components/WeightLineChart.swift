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
				ForEach(chartData) { weights in
					AreaMark(
						x: .value("Day", weights.date, unit: .day),
						y: .value("Value", weights.value)
					)
					.foregroundStyle(Gradient(colors: [.blue.opacity(0.5), .clear]))

					LineMark(
						x: .value("Day", weights.date, unit: .day),
						y: .value("Value", weights.value)
					)
				}
			}
			.frame(height: 150)
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}
}

#Preview {
	WeightLineChart(selectedTab: .weight, chartData: MockData.weights)
}
