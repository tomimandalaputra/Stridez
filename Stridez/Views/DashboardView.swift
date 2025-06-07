//
//  DashboardView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct DashboardView: View {
	@AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
	@State private var isShowingPermissionPrimingSheet = false
	@State private var selectedTab: HealthMetricContext = .steps

	private var colorNavigationStack: Color {
		selectedTab == .steps ? Color.pink : Color.indigo
	}

	fileprivate var StepsView: some View {
		VStack {
			NavigationLink(value: selectedTab) {
				HStack {
					VStack {
						Label("Steps", systemImage: "figure.walk")
							.font(.title3.bold())
							.foregroundStyle(.pink)

						Text("Avg: 10K Steps")
							.font(.caption)
					}

					Spacer()

					Image(systemName: "chevron.right")
				}
			}
			.foregroundStyle(.secondary)
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
					Picker("Selected Tab", selection: $selectedTab) {
						ForEach(HealthMetricContext.allCases) {
							Text($0.title).tag($0)
						}
					}
					.pickerStyle(.segmented)

					StepsView
					AveragesView
				}
			}
			.padding()
			.onAppear {
				isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
			}
			.navigationTitle("Dashboard")
			.navigationDestination(for: HealthMetricContext.self) { metric in
				HealthDataListView(metric: metric)
			}
			.sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
				// fetch health data
			}, content: {
				HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
			})
		}
		.tint(colorNavigationStack)
	}
}

#Preview {
	DashboardView()
		.environment(HealthKitManager())
}
