import Foundation
import Combine

class ConnectionViewModel: ObservableObject {
    @Published var hostname = ""
    @Published var port = 6667
    @Published var useTLS = true
    @Published var nickname = ""
    @Published var alternateNickname = ""
    @Published var username = ""
    @Published var realName = ""
    @Published var serverPassword = ""
    @Published var saslUsername = ""
    @Published var saslPassword = ""
    @Published var isConnecting = false
    @Published var error: String?
    
    private var connection: IRCConnection?
    private var cancellables = Set<AnyCancellable>()
    
    func connect() {
        guard !hostname.isEmpty && !nickname.isEmpty && !username.isEmpty else {
            error = "Required fields cannot be empty"
            return
        }
        
        isConnecting = true
        
        let credentials = IRCCredentials(
            nickname: nickname,
            alternateNickname: alternateNickname,
            username: username,
            realName: realName,
            serverPassword: serverPassword.isEmpty ? nil : serverPassword,
            saslUsername: saslUsername.isEmpty ? nil : saslUsername,
            saslPassword: saslPassword.isEmpty ? nil : saslPassword
        )
        
        connection = IRCConnection(
            host: hostname,
            port: useTLS ? 6697 : 6667,
            useTLS: useTLS,
            credentials: credentials
        )
        
        connection?.connect().sink(
            receiveCompletion: { [weak self] completion in
                self?.isConnecting = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            },
            receiveValue: { [weak self] _ in
                self?.isConnecting = false
                // Notify success
            }
        ).store(in: &cancellables)
    }
} 