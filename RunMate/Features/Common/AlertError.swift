import Foundation

struct AlertError: LocalizedError {
    struct Action {
        let title: String
        let handler: () -> Void
    }
    let title: String
    let message: String
    let primaryAction: Action
    let secondaryAction: Action?
    
    // Shows up as Title of alert.
    var errorDescription: String? {
        return title
    }
}
