//
//  StepPieChart.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Charts
import SwiftUI

struct StepPieChart: View {
	var chartData: [WeekdayChartData]

	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Label("Averages", systemImage: "calendar")
					.font(.title3.bold())
					.foregroundStyle(.pink)

				Text("Last 10 Days")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			.padding(.bottom, 12)

			Chart {
				ForEach(chartData) { weekday in
					SectorMark(
						angle: .value("Average Steps", weekday.value),
						innerRadius: .ratio(0.618),
						angularInset: 1
					)
					.foregroundStyle(Color.pink.gradient)
					.cornerRadius(8)
				}
			}
//			.chartLegend(.hidden)
			.frame(height: 240)
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}
}

#Preview {
	StepPieChart(chartData: ChartMath.averageWeekDayCount(for: HealthMetric.mockData))
}
