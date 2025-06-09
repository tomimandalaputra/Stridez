//
//  ChartContainer.swift
//  Stridez
//
//  Created by tukucode on 09/06/25.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
	let chartType: ChartType

	@ViewBuilder var content: () -> Content

	var isNav: Bool {
		switch chartType {
			case .stepBar, .weightLine:
				return true
			case .stepWeekdayPie, .weightDiffBar:
				return false
		}
	}

	var context: HealthMetricContext {
		switch chartType {
			case .stepBar, .stepWeekdayPie:
				return .steps
			case .weightLine, .weightDiffBar:
				return .weight
		}
	}

	var title: String {
		switch chartType {
			case .stepBar:
				return "Steps"
			case .stepWeekdayPie:
				return "Averages"
			case .weightLine:
				return "Weight"
			case .weightDiffBar:
				return "Average Weight Change"
		}
	}

	var symbol: String {
		switch chartType {
			case .stepBar:
				return "figure.walk"
			case .stepWeekdayPie:
				return "calendar"
			case .weightLine, .weightDiffBar:
				return "figure"
		}
	}

	var subtitle: String {
		switch chartType {
			case .stepBar(let average):
				return "Avg: \(average.formatted()) steps"
			case .stepWeekdayPie:
				return "Last 28 Days"
			case .weightLine(let average):
				return "Avg: \(average.formatted(.number.precision(.fractionLength(1)))) lbs"
			case .weightDiffBar:
				return "Per Weekday (Last 28 days)"
		}
	}

	var accessibilityLabel: String {
		switch chartType {
			case .stepBar(let average):
				return "Bar chart, step count, last 28 days, average steps per day: \(average.formatted()) steps"
			case .stepWeekdayPie:
				return "Pei chart, average steps per weekday"
			case .weightLine(let average):
				return "Line chart, weight, average weight: \(average.formatted(.number.precision(.fractionLength(1)))) pounds, goal weight: 138 pounds"
			case .weightDiffBar:
				return "Bar chart, average weight difference per weekday"
		}
	}

	var body: some View {
		VStack(alignment: .leading) {
			if isNav {
				navigationLinkView
			} else {
				titleView
					.foregroundStyle(.secondary)
					.padding(.bottom, 12)
			}

			content()
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}

	fileprivate var titleView: some View {
		VStack(alignment: .leading) {
			Label(title, systemImage: symbol)
				.font(.title3.bold())
				.foregroundStyle(context == .steps ? .pink : .indigo)

			Text(subtitle)
				.font(.caption)
		}
		.accessibilityAddTraits(.isHeader)
		.accessibilityLabel(accessibilityLabel)
		.accessibilityElement(children: .ignore)
	}

	fileprivate var navigationLinkView: some View {
		NavigationLink(value: context) {
			HStack {
				titleView
				Spacer()
				Image(systemName: "chevron.right")
			}
		}
		.foregroundStyle(.secondary)
		.padding(.bottom, 12)
		.accessibilityHint("Tap data to see the list view")
		.accessibilityRemoveTraits(.isButton)
	}
}

#Preview {
	ChartContainer(chartType: .stepWeekdayPie) {
		Text("Chart goes here.")
	}
}
