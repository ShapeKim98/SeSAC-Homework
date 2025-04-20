//
//  트렌딩데이터.swift
//  Dobong_Crypto
//
//  Created by Bran on 3/6/25.
//

import Foundation

struct Trending: Decodable, Equatable {
    let coins: [TrendingCoinItem]
    let nfts: [TrendingNFTItem]
}

extension Trending {
    struct TrendingCoinItem: Decodable, Hashable, Identifiable {
        let id: String
        let item: TrendingCoinDetails
        
        enum CodingKeys: CodingKey {
            case item
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.item = try container.decode(TrendingCoinDetails.self, forKey: .item)
            self.id = item.id
        }
        
        init(id: String, item: TrendingCoinDetails) {
            self.id = id
            self.item = item
        }
    }
}

extension Trending.TrendingCoinItem {
    struct TrendingCoinDetails: Decodable, Hashable {
        let id: String
        let coinId: Int
        let name: String
        let symbol: String
        let marketCapRank: Int
        let small: String
        let score: Int
        let data: TrendingCoinData
        
        enum CodingKeys: String, CodingKey {
            case id, name, symbol, small, score, data
            case coinId = "coin_id"
            case marketCapRank = "market_cap_rank"
        }
    }
}

extension Trending.TrendingCoinItem.TrendingCoinDetails {
    struct TrendingCoinData: Decodable, Hashable {
        let priceChangePercentage24h: Percentage
        
        enum CodingKeys: String, CodingKey {
            case priceChangePercentage24h = "price_change_percentage_24h"
        }
    }
}

extension Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData {
    struct Percentage: Decodable, Hashable {
        let krw: Double
    }
}

extension Trending {
    struct TrendingNFTItem: Decodable, Hashable, Identifiable {
        let id: String
        let name: String
        let symbol: String
        let thumb: String
        let floorPrice24hPercentageChange: Double
        let data: TrendingNFTData
        
        enum CodingKeys: String, CodingKey {
            case floorPrice24hPercentageChange = "floor_price_24h_percentage_change"
            case id, name, symbol, thumb, data
        }
    }
}

extension Trending.TrendingNFTItem {
    struct TrendingNFTData: Decodable, Hashable {
        let floorPrice: String
        
        enum CodingKeys: String, CodingKey {
            case floorPrice = "floor_price"
        }
    }
}

extension Trending {
    static var mock: Trending {
        Trending(
            coins: [
                TrendingCoinItem(
                    id: "voxies",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "voxies",
                        coinId: 21260,
                        name: "Voxies",
                        symbol: "VOXEL",
                        marketCapRank: 880,
                        small: "https://coin-images.coingecko.com/coins/images/21260/small/Voxies_color_icon.png?1715217306",
                        score: 0,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 234.05494536660308)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "connect-token-wct",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "connect-token-wCt",
                        coinId: 50390,
                        name: "WalletConnect Token",
                        symbol: "WCT",
                        marketCapRank: 445,
                        small: "https://coin-images.coingecko.com/coins/images/50390/small/wc-token1.png?1727569464",
                        score: 1,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 44.48621400255899)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "hyperliquid",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "hyperliquid",
                        coinId: 50882,
                        name: "Hyperliquid",
                        symbol: "HYPE",
                        marketCapRank: 24,
                        small: "https://coin-images.coingecko.com/coins/images/50882/small/hyperliquid.jpg?1729431300",
                        score: 2,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 5.799751153202096)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "pi-network",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "pi-network",
                        coinId: 54342,
                        name: "Pi Network",
                        symbol: "PI",
                        marketCapRank: 30,
                        small: "https://coin-images.coingecko.com/coins/images/54342/small/pi_network.jpg?1739347576",
                        score: 3,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: -1.2376026847710875)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "mantra-dao",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "mantra-dao",
                        coinId: 12151,
                        name: "MANTRA",
                        symbol: "OM",
                        marketCapRank: 124,
                        small: "https://coin-images.coingecko.com/coins/images/12151/small/OM_Token.png?1696511991",
                        score: 4,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: -6.211929714490936)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "bittensor",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "bittensor",
                        coinId: 28452,
                        name: "Bittensor",
                        symbol: "TAO",
                        marketCapRank: 45,
                        small: "https://coin-images.coingecko.com/coins/images/28452/small/ARUsPeNQ_400x400.jpeg?1696527447",
                        score: 5,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 8.565372208727972)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "solana",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "solana",
                        coinId: 4128,
                        name: "Solana",
                        symbol: "SOL",
                        marketCapRank: 6,
                        small: "https://coin-images.coingecko.com/coins/images/4128/small/solana.png?1718769756",
                        score: 6,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 1.5596412691512764)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "fartcoin",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "fartcoin",
                        coinId: 50891,
                        name: "Fartcoin",
                        symbol: "FARTCOIN",
                        marketCapRank: 94,
                        small: "https://coin-images.coingecko.com/coins/images/50891/small/fart.jpg?1729503972",
                        score: 7,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 6.338665944656493)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "bitcoin",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "bitcoin",
                        coinId: 1,
                        name: "Bitcoin",
                        symbol: "BTC",
                        marketCapRank: 1,
                        small: "https://coin-images.coingecko.com/coins/images/1/small/bitcoin.png?1696501400",
                        score: 8,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 0.337913138329549)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "ronin",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "ronin",
                        coinId: 20009,
                        name: "Ronin",
                        symbol: "RON",
                        marketCapRank: 197,
                        small: "https://coin-images.coingecko.com/coins/images/20009/small/photo_2024-04-06_22-52-24.jpg?1712415367",
                        score: 9,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 1.705610934999803)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "berachain-bera",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "berachain-bera",
                        coinId: 25235,
                        name: "Berachain",
                        symbol: "BERA",
                        marketCapRank: 169,
                        small: "https://coin-images.coingecko.com/coins/images/25235/small/BERA.png?1738822008",
                        score: 10,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 2.473538925101969)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "polkadot",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "polkadot",
                        coinId: 12171,
                        name: "Polkadot",
                        symbol: "DOT",
                        marketCapRank: 25,
                        small: "https://coin-images.coingecko.com/coins/images/12171/small/polkadot.png?1696512008",
                        score: 11,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 4.331528075468077)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "grass",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "grass",
                        coinId: 40094,
                        name: "Grass",
                        symbol: "GRASS",
                        marketCapRank: 141,
                        small: "https://coin-images.coingecko.com/coins/images/40094/small/Grass.jpg?1725697048",
                        score: 12,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 1.683950626366066)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "aleo",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "aleo",
                        coinId: 27916,
                        name: "ALEO",
                        symbol: "ALEO",
                        marketCapRank: 395,
                        small: "https://coin-images.coingecko.com/coins/images/27916/small/secondary-icon-dark.png?1726770428",
                        score: 13,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 40.65682165146396)
                        )
                    )
                ),
                TrendingCoinItem(
                    id: "based-brett",
                    item: TrendingCoinItem.TrendingCoinDetails(
                        id: "based-brett",
                        coinId: 35529,
                        name: "Brett",
                        symbol: "BRETT",
                        marketCapRank: 173,
                        small: "https://coin-images.coingecko.com/coins/images/35529/small/1000050750.png?1709031995",
                        score: 14,
                        data: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                            priceChangePercentage24h: TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(krw: 5.340584553284178)
                        )
                    )
                )
            ],
            nfts: [
                TrendingNFTItem(
                    id: "murakami-flowers-official",
                    name: "Murakami.Flowers Official",
                    symbol: "M.F",
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/913/standard/murakami-flowers-official.png?1707287562",
                    floorPrice24hPercentageChange: 43.86462372277597,
                    data: TrendingNFTItem.TrendingNFTData(floorPrice: "0.40 ETH")
                ),
                TrendingNFTItem(
                    id: "cryptodickbutts",
                    name: "CryptoDickbutts",
                    symbol: "CDB",
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/1265/standard/cryptodickbutts.gif?1707287730",
                    floorPrice24hPercentageChange: 35.13492745482199,
                    data: TrendingNFTItem.TrendingNFTData(floorPrice: "0.78 ETH")
                ),
                TrendingNFTItem(
                    id: "opepen-edition",
                    name: "Opepen Edition",
                    symbol: "OPEPEN",
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2540/standard/opepen.jpeg?1707288408",
                    floorPrice24hPercentageChange: 22.1746707203369,
                    data: TrendingNFTItem.TrendingNFTData(floorPrice: "0.29 ETH")
                ),
                TrendingNFTItem(
                    id: "cryptopunks-v1-wrapped",
                    name: "CryptoPunks V1 (wrapped)",
                    symbol: "WPV1",
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/479/standard/cryptopunks-v1-wrapped.png?1707287336",
                    floorPrice24hPercentageChange: 19.74557329279665,
                    data: TrendingNFTItem.TrendingNFTData(floorPrice: "2.49 ETH")
                ),
                TrendingNFTItem(
                    id: "bored-ape-kennel-club",
                    name: "Bored Ape Kennel Club",
                    symbol: "BAKC",
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/233/standard/bored-ape-kennel-club.png?1707287231",
                    floorPrice24hPercentageChange: 12.35523447073876,
                    data: TrendingNFTItem.TrendingNFTData(floorPrice: "0.65 ETH")
                ),
                TrendingNFTItem(
                    id: "wealthy-hypio-babies",
                    name: "Wealthy Hypio Babies",
                    symbol: "HYPIO",
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15671/standard/wealthy-hypio-babies.png?1741099389",
                    floorPrice24hPercentageChange: 10.07014013216132,
                    data: TrendingNFTItem.TrendingNFTData(floorPrice: "1.80 ETH")
                ),
                TrendingNFTItem(
                    id: "redacted-remilio-babies",
                    name: "Redacted Remilio Babies",
                    symbol: "TEST",
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2736/standard/redacted-remilio-babies.?1707289665",
                    floorPrice24hPercentageChange: 9.724167962018093,
                    data: TrendingNFTItem.TrendingNFTData(floorPrice: "0.53 ETH")
                )
            ]
        )
    }
}
