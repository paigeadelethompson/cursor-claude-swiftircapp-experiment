import SwiftUI

struct ConnectionView: View {
    @StateObject private var viewModel = ConnectionViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Server Details")) {
                TextField("Hostname", text: $viewModel.hostname)
                    .textContentType(.URL)
                
                HStack {
                    TextField("Port", value: $viewModel.port, format: .number)
                        .frame(width: 80)
                    
                    Toggle("Use TLS", isOn: $viewModel.useTLS)
                }
            }
            
            Section(header: Text("User Details")) {
                TextField("Nickname", text: $viewModel.nickname)
                TextField("Alternate Nickname", text: $viewModel.alternateNickname)
                TextField("Username", text: $viewModel.username)
                TextField("Real Name", text: $viewModel.realName)
            }
            
            Section(header: Text("Authentication (Optional)")) {
                SecureField("Server Password", text: $viewModel.serverPassword)
                
                TextField("SASL Username", text: $viewModel.saslUsername)
                SecureField("SASL Password", text: $viewModel.saslPassword)
            }
            
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button(action: viewModel.connect) {
                if viewModel.isConnecting {
                    ProgressView()
                } else {
                    Text("Connect")
                }
            }
            .disabled(viewModel.isConnecting)
        }
        .padding()
        #if os(macOS)
        .frame(width: 400)
        #endif
    }
} 