import SwiftUI

struct TutorChatMessage: Identifiable, Equatable {
    enum Role: String, Codable {
        case user
        case assistant
    }

    let id: UUID
    let role: Role
    let text: String

    init(id: UUID = UUID(), role: Role, text: String) {
        self.id = id
        self.role = role
        self.text = text
    }
}

struct TutorView: View {
    private static let welcomeMessage = TutorChatMessage(
        role: .assistant,
        text: "Hi! I’m your SkillSync AI tutor. Choose a starter question or tell me what you’re learning. I’ll guide you with questions and hints instead of simply giving away the answer."
    )

    private let starterQuestions = [
        "Quiz me on the periodic table",
        "Help me understand atomic numbers",
        "Give me a science recall challenge"
    ]

    private let initialPrompt: String?
    private let isPresentedModally: Bool
    private let contextTitle: String?
    private let studyContext: String?

    @State private var messages: [TutorChatMessage]
    @State private var draft = ""
    @State private var isSending = false
    @State private var hasSentInitialPrompt = false
    @State private var errorMessage: String?
    @FocusState private var isComposerFocused: Bool
    @Environment(\.skillSyncAnimationsEnabled) private var animationsEnabled
    @Environment(\.dismiss) private var dismiss

    init(
        initialPrompt: String? = nil,
        isPresentedModally: Bool = false,
        contextTitle: String? = nil,
        studyContext: String? = nil
    ) {
        self.initialPrompt = initialPrompt
        self.isPresentedModally = isPresentedModally
        self.contextTitle = contextTitle
        self.studyContext = studyContext
        _messages = State(initialValue: [TutorView.welcomeMessage])
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AmbientBackgroundView(isAnimated: animationsEnabled)

                GlowingWaveOverlay(
                    intensity: 0.3,
                    verticalOffset: -150,
                    isAnimated: animationsEnabled
                )

                VStack(spacing: 0) {
                    tutorHeader

                    Divider()
                        .overlay(.white.opacity(0.12))

                    messageList

                    if let errorMessage {
                        connectionError(message: errorMessage)
                    }

                    composer
                }
                .padding(.bottom, isPresentedModally ? 0 : 78)
            }
            .navigationBarHidden(true)
        }
        .task {
            guard !hasSentInitialPrompt,
                  let initialPrompt,
                  !initialPrompt.isEmpty else { return }
            hasSentInitialPrompt = true
            send(initialPrompt)
        }
    }

    private var tutorHeader: some View {
        HStack(spacing: 13) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 46, height: 46)
            .shadow(color: .cyan.opacity(0.35), radius: 16)

            VStack(alignment: .leading, spacing: 3) {
                Text(contextTitle ?? "SkillSync AI Tutor")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Label(
                    studyContext == nil
                        ? "Guided recall and helpful hints"
                        : "Element table knowledge loaded",
                    systemImage: studyContext == nil
                        ? "brain.head.profile"
                        : "checkmark.seal.fill"
                )
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.cyan.opacity(0.82))
            }

            Spacer()

            if isPresentedModally {
                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.cyan)
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        messages = [TutorView.welcomeMessage]
                        errorMessage = nil
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.76))
                        .frame(width: 38, height: 38)
                        .background(.white.opacity(0.08), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Start a new tutoring chat")
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(messages) { message in
                        TutorMessageBubble(message: message)
                            .id(message.id)
                    }

                    if messages.count == 1 {
                        starterQuestionButtons
                    }

                    if isSending {
                        HStack {
                            TutorTypingIndicator()
                            Spacer(minLength: 54)
                        }
                        .id("typing")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: messages.count) {
                scrollToLatest(using: proxy)
            }
            .onChange(of: isSending) {
                scrollToLatest(using: proxy)
            }
        }
    }

    private var starterQuestionButtons: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TRY ASKING")
                .font(.system(size: 11, weight: .black, design: .rounded))
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.42))

            ForEach(starterQuestions, id: \.self) { question in
                Button {
                    send(question)
                } label: {
                    HStack {
                        Text(question)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                    }
                    .foregroundStyle(.white.opacity(0.82))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 13)
                    .background(.white.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .cyan.opacity(0.32),
                                        .purple.opacity(0.2)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    }
                }
                .buttonStyle(.plain)
                .disabled(isSending)
            }
        }
        .padding(.top, 8)
    }

    private func connectionError(message: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "wifi.exclamationmark")
                .foregroundStyle(.orange)

            Text(message)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.76))

            Spacer()
        }
        .padding(12)
        .background(.orange.opacity(0.1))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.orange.opacity(0.35))
                .frame(height: 1)
        }
    }

    private var composer: some View {
        VStack(alignment: .leading, spacing: 7) {
            Label("YOUR REPLY", systemImage: "keyboard")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(.cyan.opacity(0.82))

            HStack(alignment: .bottom, spacing: 10) {
                TextField(
                    "Type your answer or ask a question…",
                    text: $draft,
                    axis: .vertical
                )
                    .focused($isComposerFocused)
                    .lineLimit(1...4)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 13)
                    .background(.black.opacity(0.32))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                isComposerFocused
                                    ? Color.cyan.opacity(0.82)
                                    : Color.white.opacity(0.22),
                                lineWidth: isComposerFocused ? 1.5 : 1
                            )
                    }
                    .submitLabel(.send)
                    .onSubmit {
                        sendDraft()
                    }

                Button {
                    sendDraft()
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                canSend
                                    ? AnyShapeStyle(
                                        LinearGradient(
                                            colors: [.cyan, .blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    : AnyShapeStyle(.white.opacity(0.1))
                            )

                        if isSending {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 17, weight: .black))
                                .foregroundStyle(
                                    canSend ? .white : .white.opacity(0.28)
                                )
                        }
                    }
                    .frame(width: 48, height: 48)
                }
                .buttonStyle(.plain)
                .disabled(!canSend)
                .accessibilityLabel("Send message")
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 9)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.white.opacity(0.1))
                .frame(height: 1)
        }
    }

    private var canSend: Bool {
        !isSending && !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sendDraft() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        draft = ""
        send(text)
    }

    private func send(_ text: String) {
        guard !isSending else { return }

        let userMessage = TutorChatMessage(role: .user, text: text)
        messages.append(userMessage)
        errorMessage = nil
        isSending = true
        isComposerFocused = false

        let conversation = messages

        Task {
            do {
                let reply = try await TutorAPI.ask(
                    messages: conversation,
                    studyContext: studyContext
                )
                messages.append(
                    TutorChatMessage(role: .assistant, text: reply)
                )
            } catch {
                errorMessage = error.localizedDescription
            }

            isSending = false
        }
    }

    private func scrollToLatest(using proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) {
            if isSending {
                proxy.scrollTo("typing", anchor: .bottom)
            } else if let lastMessage = messages.last {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

private struct TutorMessageBubble: View {
    let message: TutorChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 9) {
            if message.role == .user {
                Spacer(minLength: 44)
            } else {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.cyan)
                    .frame(width: 28, height: 28)
                    .background(.cyan.opacity(0.12), in: Circle())
            }

            Text(message.text)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.92))
                .textSelection(.enabled)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background {
                    if message.role == .user {
                        LinearGradient(
                            colors: [
                                .blue.opacity(0.72),
                                .purple.opacity(0.72)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.white.opacity(0.08)
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }

            if message.role == .assistant {
                Spacer(minLength: 44)
            }
        }
    }
}

private struct TutorTypingIndicator: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.cyan)
                .frame(width: 28, height: 28)
                .background(.cyan.opacity(0.12), in: Circle())

            HStack(spacing: 7) {
                ProgressView()
                    .controlSize(.small)
                    .tint(.cyan)

                Text("Thinking of the best next hint…")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.62))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(.white.opacity(0.07))
            .clipShape(Capsule())
        }
    }
}

private enum TutorAPI {
    private static let endpoints = [
        URL(string: "http://Olivers-Mac-mini.local:8787/tutor")!,
        URL(string: "http://192.168.1.32:8787/tutor")!
    ]

    static func ask(
        messages: [TutorChatMessage],
        studyContext: String?
    ) async throws -> String {
        let payloadMessages = messages
            .suffix(14)
            .map {
                TutorRequestMessage(
                    role: $0.role.rawValue,
                    content: String($0.text.prefix(2_000))
                )
            }

        let body = TutorRequest(
            messages: payloadMessages,
            studyContext: studyContext
        )
        let encodedBody = try JSONEncoder().encode(body)
        var lastConnectionError: Error?

        for endpoint in endpoints {
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            request.timeoutInterval = 90
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            request.httpBody = encodedBody

            do {
                let (data, response) = try await URLSession.shared.data(
                    for: request
                )

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw TutorAPIError.invalidResponse
                }

                if (200..<300).contains(httpResponse.statusCode) {
                    let decoded = try JSONDecoder().decode(
                        TutorResponse.self,
                        from: data
                    )

                    let reply = decoded.reply.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

                    guard !reply.isEmpty else {
                        throw TutorAPIError.invalidResponse
                    }

                    return reply
                }

                let decodedError = try? JSONDecoder().decode(
                    TutorErrorResponse.self,
                    from: data
                )
                throw TutorAPIError.server(
                    decodedError?.error
                        ?? "The tutor server returned an error."
                )
            } catch let error as TutorAPIError {
                throw error
            } catch {
                lastConnectionError = error
            }
        }

        throw TutorAPIError.unreachable(
            underlying: lastConnectionError
        )
    }
}

private struct TutorRequest: Encodable {
    let messages: [TutorRequestMessage]
    let studyContext: String?

    enum CodingKeys: String, CodingKey {
        case messages
        case studyContext = "study_context"
    }
}

private struct TutorRequestMessage: Encodable {
    let role: String
    let content: String
}

private struct TutorResponse: Decodable {
    let reply: String
}

private struct TutorErrorResponse: Decodable {
    let error: String
}

private enum TutorAPIError: LocalizedError {
    case invalidResponse
    case server(String)
    case unreachable(underlying: Error?)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The tutor sent an unreadable response. Please try again."
        case .server(let message):
            return message
        case .unreachable:
            return "Couldn’t reach the tutor server. Keep this iPhone and your Mac on the same Wi-Fi, then start server/start-tutor.command on the Mac."
        }
    }
}
