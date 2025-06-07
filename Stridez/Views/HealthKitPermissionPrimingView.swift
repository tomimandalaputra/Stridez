//
//  HealthKitPermissionPrimingView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct HealthKitPermissionPrimingView: View {
	private var description: String = """
	This app displays your step and weight data in intractive charts.

	You can also add new step or weight ada to Apple Health from this app. Your data is private and secured.
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

			Button(action: {}, label: {
				Text("Connect Apple Health")
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity)
					.frame(height: 34)
			})
			.buttonStyle(.borderedProminent)
			.tint(.pink)
		}
		.padding()
	}
}

#Preview {
	HealthKitPermissionPrimingView()
}
