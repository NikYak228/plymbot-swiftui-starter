import Foundation

struct PreviewMessage: Identifiable {
    let id = UUID()
    let isUser: Bool
    let text: String
}

struct PreviewModel: Identifiable {
    let id: String
    let name: String
    let detail: String
    let symbol: String

    static let catalog = [
        PreviewModel(id: "auto", name: "Auto", detail: "Routing interface preview", symbol: "sparkles"),
        PreviewModel(id: "openai", name: "OpenAI", detail: "Provider placeholder", symbol: "circle.hexagongrid"),
        PreviewModel(id: "anthropic", name: "Anthropic", detail: "Provider placeholder", symbol: "sun.max"),
        PreviewModel(id: "google", name: "Google", detail: "Provider placeholder", symbol: "diamond")
    ]
}
