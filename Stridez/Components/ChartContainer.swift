//
//  ChartContainer.swift
//  Stridez
//
//  Created by tukucode on 09/06/25.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
	let title: String
	let symbol: String
	let subtitle: String
	let context: HealthMetricContext
	let isNav: Bool

	@ViewBuilder var content: () -> Content

	fileprivate var titleView: some View {
		VStack(alignment: .leading) {
			Label(title, systemImage: symbol)
				.font(.title3.bold())
				.foregroundStyle(context == .steps ? .pink : .indigo)

			Text(subtitle)
				.font(.caption)
		}
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
}

#Preview {
	ChartContainer(
		title: "Title",
		symbol: "figure.walk",
		subtitle: "Subtitle",
		context: .steps,
		isNav: true
	) {
		Text("Chart goes here.")
	}
}
