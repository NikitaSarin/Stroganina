struct AuthorisationInfo: Encodable {
    let token: String
    let secretKey: String

    init(token: String, secretKey: String) {
        self.token = token
        self.secretKey = String(secretKey.prefix(64))
    }
}
