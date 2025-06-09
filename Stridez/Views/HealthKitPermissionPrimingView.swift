//
//  HealthKitPermissionPrimingView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import HealthKitUI
import SwiftUI

struct HealthKitPermissionPrimingView: View {
	@Environment(HealthKitManager.self) private var hkManager
	@Environment(\.dismiss) private var dismiss
	@State private var isShowingHealthKitPermissions = false

	var description = """
	This app displays your step and weight data in interactive charts.

	You can also add new step or weight data to Apple Health from this app. Your data is private and secured.
	"""

	var body: some View {
		VStack(alignment: .leading) {
			Spacer()

			Image(.appleHealth)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 90, height: 90)
				.shadow(color: .gray.opacity(0.3), radius: 16)

			Text("Apple Health Integration")
				.font(.title2.bold())
				.padding(.top, 12)
				.padding(.bottom, 16)

			Text(description)
				.foregroundStyle(.secondary)

			Spacer()

			Button(action: {
				isShowingHealthKitPermissions = true
			}, label: {
				Text("Connect Apple Health")
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity)
					.frame(height: 34)
			})
			.buttonStyle(.borderedProminent)
			.tint(.pink)
		}
		.padding()
		.healthDataAccessRequest(store: hkManager.store,
		                         shareTypes: hkManager.types,
		                         readTypes: hkManager.types,
		                         trigger: isShowingHealthKitPermissions)
		{ result in
			switch result {
			case .success:
				Task { @MainActor in dismiss() }
			case .failure:
				// handle the error later
				Task { @MainActor in dismiss() }
			}
		}
	}
}

#Preview {
	HealthKitPermissionPrimingView()
		.environment(HealthKitManager())
}
