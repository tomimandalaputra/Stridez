//
//  DashboardView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct DashboardView: View {
	fileprivate var StepsView: some View {
		VStack {
			HStack {
				VStack {
					Label("Steps", systemImage: "figure.walk")
						.font(.title3.bold())
						.foregroundStyle(.pink)

					Text("Avg: 10K Steps")
						.font(.caption)
						.foregroundStyle(.secondary)
				}

				Spacer()

				Image(systemName: "chevron.right")
					.foregroundStyle(.secondary)
			}
			.padding(.bottom, 12)

			RoundedRectangle(cornerRadius: 12)
				.foregroundStyle(.secondary)
				.frame(height: 200)
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}

	fileprivate var AveragesView: some View {
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

			RoundedRectangle(cornerRadius: 12)
				.foregroundStyle(.secondary)
				.frame(height: 240)
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 24) {
					StepsView
					AveragesView
				}
			}
			.padding()
			.navigationTitle("Dashboard")
		}
	}
}

#Preview {
	DashboardView()
}
