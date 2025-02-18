import Foundation
import WalletConnectNetworking
import Web3Wallet
import Web3Inbox

final class ConfigurationService {

    func configure(importAccount: ImportAccount) {
        Networking.configure(projectId: InputConfig.projectId, socketFactory: DefaultSocketFactory())
        Networking.instance.setLogging(level: .debug)

        let metadata = AppMetadata(
            name: "Example Wallet",
            description: "wallet description",
            url: "example.wallet",
            icons: ["https://avatars.githubusercontent.com/u/37784886"]
        )

        Web3Wallet.configure(metadata: metadata, crypto: DefaultCryptoProvider(), environment: BuildConfiguration.shared.apnsEnvironment)

        Web3Inbox.configure(
            account: importAccount.account,
            bip44: DefaultBIP44Provider(),
            config: [.chatEnabled: false, .settingsEnabled: false],
            environment: BuildConfiguration.shared.apnsEnvironment,
            crypto: DefaultCryptoProvider(),
            onSign: importAccount.onSign
        )

        if let clientId = try? Networking.interactor.getClientId() {
            LoggingService.instance.setUpUser(account: importAccount.account.absoluteString, clientId: clientId)
        }
        LoggingService.instance.startLogging()
    }
}
