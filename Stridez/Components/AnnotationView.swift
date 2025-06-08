//
//  AnnotationView.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import SwiftUI

struct AnnotationView: View {
	var seletedDate: Date?
	var seletedValue: Double?
	var fractionLenghtValue: Int = 0
	var styleTextColor: Color = .pink

	private var showTextDate: Date {
		guard let seletedDate else {
			return .now
		}

		return seletedDate
	}

	private var showTextValue: Double {
		guard let seletedValue else {
			return 0
		}

		return seletedValue
	}

	var body: some View {
		VStack {
			Text(showTextDate, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
				.font(.footnote.bold())
				.foregroundStyle(Color.secondary)

			Text(showTextValue, format: .number.precision(.fractionLength(fractionLenghtValue)))
				.fontWeight(.heavy)
				.foregroundStyle(styleTextColor)
		}
		.padding(12)
		.background(
			RoundedRectangle(cornerRadius: 4)
				.fill(Color(.secondarySystemBackground))
				.shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
		)
	}
}

#Preview {
	AnnotationView(seletedDate: .now, seletedValue: 99.1234)
}
