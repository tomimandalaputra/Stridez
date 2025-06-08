//
//  WeightDiffBarChart.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Charts
import SwiftUI

struct WeightDiffBarChart: View {
	@State private var rawSelectedDate: Date?

	var chartData: [DailyWeightData]
	var selectedData: DailyWeightData? {
		guard let rawSelectedDate else { return nil }
		return chartData.first {
			Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
		}
	}

	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Label("Average Weight Change", systemImage: "figure")
					.font(.title3.bold())
					.foregroundStyle(Color.indigo)

				Text("Per Weekday (Last 28 days)")
					.font(.caption)
					.foregroundStyle(Color.secondary)
			}
			.padding(.bottom, 12)

			Chart {
				if let selectedData {
					RuleMark(x: .value("Selected Data", selectedData.date, unit: .day))
						.foregroundStyle(Color.secondary.opacity(0.3))
						.offset(y: -10)
						.annotation(
							position: .top,
							alignment: .center,
							spacing: 0,
							overflowResolution: .init(x: .fit(to: .chart), y: .disabled),
							content: {
								AnnotationView(
									seletedDate: selectedData.date,
									seletedValue: selectedData.value,
									fractionLenghtValue: 2,
									styleTextColor: selectedData.value >= 0 ? Color.indigo : Color.mint
								)
							}
						)
				}

				ForEach(chartData) { weightDiff in
					BarMark(
						x: .value("Date", weightDiff.date, unit: .day),
						y: .value("Weight Diffs", weightDiff.value)
					)
					.foregroundStyle(weightDiff.value >= 0 ? Color.indigo.gradient : Color.mint.gradient)
					.opacity(rawSelectedDate == nil || weightDiff.date == selectedData?.date ? 1.0 : 0.3)
				}
			}
			.frame(height: 150)
			.chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
			.chartXAxis {
				AxisMarks(values: .stride(by: .day)) {
					AxisValueLabel(format: .dateTime.weekday(), centered: true)
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
	WeightDiffBarChart(chartData: MockData.weightDiffs)
}
