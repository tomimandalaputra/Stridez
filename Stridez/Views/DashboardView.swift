//
//  DashboardView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct DashboardView: View {
	@Environment(HealthKitManager.self) private var hkManager

	@State private var viewModel = DashboardViewModel()
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
				do {
					try await hkManager.fetchStepCount()
					try await hkManager.fetchWeights()
					try await hkManager.fetchWeightForDifferentials()
				} catch CustomError.authNotDetermined {
					viewModel.isShowingPermissionPrimingSheet = true
				} catch CustomError.noData {
					print("❌ No data error")
				} catch {
					print("❌ Unabled to complete request")
				}
			}
			.navigationTitle("Dashboard")
			.navigationDestination(for: HealthMetricContext.self) { metric in
				HealthDataListView(metric: metric)
			}
			.sheet(isPresented: $viewModel.isShowingPermissionPrimingSheet, onDismiss: {
				// fetch health data
			}, content: {
				HealthKitPermissionPrimingView()
			})
		}
		.tint(colorNavigationStack)
	}
}

#Preview {
	DashboardView()
		.environment(HealthKitManager())
}
