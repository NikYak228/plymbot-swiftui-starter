import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var model = PreviewModel.catalog[0]
    @State private var draft = ""
    @State private var messages: [PreviewMessage] = []

    var body: some View {
        TabView(selection: $selectedTab) {
            chat
                .tabItem { Label("Chat", systemImage: "bubble.left.and.bubble.right") }
                .tag(0)
            models
                .tabItem { Label("Models", systemImage: "square.grid.2x2") }
                .tag(1)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "slider.horizontal.3") }
                .tag(2)
        }
    }

    private var chat: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Label("Local UI preview", systemImage: "sparkles")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)

                ScrollViewReader { scroll in
                    ScrollView {
                        if messages.isEmpty {
                            welcome
                        } else {
                            LazyVStack(alignment: .leading, spacing: 18) {
                                ForEach(messages) { message in
                                    MessageRow(message: message)
                                        .id(message.id)
                                }
                            }
                            .padding(20)
                        }
                    }
                    .onChange(of: messages.count) { _, _ in
                        if let last = messages.last {
                            scroll.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { composer }
            .navigationTitle("Plymbot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        ForEach(PreviewModel.catalog) { item in
                            Button {
                                model = item
                            } label: {
                                if item.id == model.id {
                                    Label(item.name, systemImage: "checkmark")
                                } else {
                                    Text(item.name)
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(model.name)
                            Image(systemName: "chevron.down").font(.caption2)
                        }
                        .font(.subheadline.weight(.medium))
                    }
                    .accessibilityLabel("Selected model: \(model.name)")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        messages.removeAll()
                        draft = ""
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .accessibilityLabel("New chat")
                }
            }
        }
    }

    private var welcome: some View {
        VStack(spacing: 18) {
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.mint)
                .accessibilityHidden(true)
            Text("A little space for big ideas.")
                .font(.system(.largeTitle, design: .serif).weight(.medium))
                .multilineTextAlignment(.center)
            Text("Your models. Your workspace.")
                .foregroundStyle(.secondary)
            VStack(spacing: 10) {
                prompt("Help me shape an idea", icon: "lightbulb")
                prompt("Explain something simply", icon: "text.bubble")
                prompt("Plan my next project", icon: "checklist")
            }
            .padding(.top, 14)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 44)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity)
    }

    private func prompt(_ title: String, icon: String) -> some View {
        Button { draft = title } label: {
            HStack {
                Label(title, systemImage: icon)
                Spacer()
                Image(systemName: "arrow.up.left").font(.caption)
            }
            .font(.subheadline)
            .foregroundStyle(.primary)
            .padding(16)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    private var composer: some View {
        HStack(alignment: .bottom, spacing: 12) {
            TextField("Ask anything…", text: $draft, axis: .vertical)
                .lineLimit(1...5)
                .padding(.vertical, 10)
                .accessibilityLabel("Message")
            Button(action: send) {
                Image(systemName: "arrow.up")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(width: 38, height: 38)
                    .background(.mint, in: Circle())
            }
            .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .accessibilityLabel("Send preview message")
        }
        .padding(10)
        .padding(.leading, 8)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 26))
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.background)
    }

    private var models: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(PreviewModel.catalog) { item in
                        Button {
                            model = item
                            selectedTab = 0
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: item.symbol)
                                    .font(.title2)
                                    .foregroundStyle(.mint)
                                    .frame(width: 34)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name).foregroundStyle(.primary)
                                    Text(item.detail).font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                if model.id == item.id {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.mint)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .accessibilityLabel("Select \(item.name)")
                    }
                } footer: {
                    Text("Illustrative model choices. This preview does not connect to providers or route requests.")
                }
            }
            .navigationTitle("Choose your model")
        }
    }

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messages.append(PreviewMessage(isUser: true, text: text))
        draft = ""
        messages.append(PreviewMessage(
            isUser: false,
            text: "You selected \(model.name). This is a local preview response so you can try the conversation layout. No request was sent to an AI provider."
        ))
    }
}

private struct MessageRow: View {
    let message: PreviewMessage

    var body: some View {
        HStack(alignment: .top) {
            if message.isUser { Spacer(minLength: 36) }
            VStack(alignment: .leading, spacing: 6) {
                Text(message.isUser ? "You" : "Plymbot · preview")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(message.text).textSelection(.enabled)
            }
            .padding(16)
            .background(
                message.isUser ? Color.mint.opacity(0.13) : Color(.secondarySystemBackground),
                in: RoundedRectangle(cornerRadius: 20)
            )
            if !message.isUser { Spacer(minLength: 12) }
        }
    }
}

#Preview {
    ContentView()
}
