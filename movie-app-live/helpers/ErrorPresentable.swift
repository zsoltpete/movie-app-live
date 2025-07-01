//
//  ErrorPresentable.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 06..
//


protocol ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel?
}

extension ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel? {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: "unexpected.error.title".localized(),
                message: "unexpected.error.message".localized(),
                dismissButtonTitle: "button.close.text".localized()
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "apierror.error.title".localized(),
                message: message,
                dismissButtonTitle: "button.close.text".localized()
            )
        case .clientError:
            return AlertModel(
                title: "clienterror.error.title".localized(),
                message: error.localizedDescription,
                dismissButtonTitle: "button.close.text".localized()
            )
        case .mappingError(let message):
            return AlertModel(
                title: "mappingerror.error.title".localized(),
                message: message,
                dismissButtonTitle: "button.close.text".localized()
            )
        case .noInternetError:
            return nil
        default:
            return AlertModel(
                title: "unexpected.error.title".localized(),
                message: "unexpected.error.message".localized(),
                dismissButtonTitle: "button.close.text".localized()
            )
        }
    }
}
