//
//  DashboardView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct DashboardView: View {
	@Environment(HealthKitManager.self) private var hkManager
	@AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
	@State private var isShowingPermissionPrimingSheet = false
	@State private var selectedTab: HealthMetricContext = .steps

	private var colorNavigationStack: Color {
		selectedTab == .steps ? Color.pink : Color.indigo
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

					switch selectedTab {
						case .steps:
							StepBarChart(
								selectedTab: selectedTab,
								chartData: hkManager.stepData
							)

							StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
						case .weight:
							WeightLineChart(
								selectedTab: selectedTab,
								chartData: hkManager.weightData
							)

							WeightDiffBarChart(chartData: ChartMath.averageDailyWeightDiffs(for: hkManager.weightDiffData))
					}
				}
			}
			.padding()
			.task {
				await hkManager.fetchStepCount()
				await hkManager.fetchWeights()
				await hkManager.fetchWeightForDifferentials()
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
