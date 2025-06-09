//
//  CustomError.swift
//  Stridez
//
//  Created by tukucode on 09/06/25.
//

import Foundation

enum CustomError: LocalizedError {
	case authNotDetermined
	case sharingDenied(quantityType: String)
	case noData
	case unableToCompleteRequest
	case invalidValue

	var errorDescription: String? {
		switch self {
			case .authNotDetermined:
				return "Need access to Health Data"
			case .sharingDenied:
				return "Sharing data denied"
			case .noData:
				return "No data"
			case .unableToCompleteRequest:
				return "unable to complete request"
			case .invalidValue:
				return "Invalid Value"
		}
	}

	var failureReason: String {
		switch self {
			case .authNotDetermined:
				return "You have not given access to your Health Data. Please go to Settings > Health > Data Access & Devices."
			case .sharingDenied(let quantityType):
				return "You have denied access to upload your \(quantityType) data. \n\nYou can change this in Settings > Health > Data Access & Devices."
			case .noData:
				return "There is no data for this Health statistic."
			case .unableToCompleteRequest:
				return "We are unable to complete your request at this time.\n\nPlease try again leter or contact support."
			case .invalidValue:
				return "Must be numeric value a maximum of one decimal place"
		}
	}
}
