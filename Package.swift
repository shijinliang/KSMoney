import PackageDescription

let package = Package(
    name: "KSMoney",
    targets: [
        Target(name: "App"),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/crypto.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/validation.git", majorVersion: 1)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

