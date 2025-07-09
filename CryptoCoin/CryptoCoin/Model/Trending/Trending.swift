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
    struct TrendingCoinDetails: Decodable, Hashable, Identifiable {
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
        let price: Double
        let priceChangePercentage24h: Percentage
        
        enum CodingKeys: String, CodingKey {
            case price
            case priceChangePercentage24h = "price_change_percentage_24h"
        }
    }
}

extension Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData {
    struct Percentage: Decodable, Hashable {
        let usd: Double
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
    static let mock: Trending = Trending(
        coins: [
            TrendingCoinItem(
                id: "voxies",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "voxies",
                    coinId: 21260,
                    name: "Voxies",
                    symbol: "VOXEL",
                    marketCapRank: 879,
                    small: "https://coin-images.coingecko.com/coins/images/21260/small/Voxies_color_icon.png?1715217306",
                    score: 0,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.12233242670219126,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 210.94753469680262)
                    )
                )
            ),
            TrendingCoinItem(
                id: "connect-token-wct",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "connect-token-wct",
                    coinId: 50390,
                    name: "WalletConnect Token",
                    symbol: "WCT",
                    marketCapRank: 429,
                    small: "https://coin-images.coingecko.com/coins/images/50390/small/wc-token1.png?1727569464",
                    score: 1,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.5351293229934171,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 55.272930781300076)
                    )
                )
            ),
            TrendingCoinItem(
                id: "mantra-dao",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "mantra-dao",
                    coinId: 12151,
                    name: "MANTRA",
                    symbol: "OM",
                    marketCapRank: 124,
                    small: "https://coin-images.coingecko.com/coins/images/12151/small/OM_Token.png?1696511991",
                    score: 2,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.6043280984595609,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: -6.276534326550057)
                    )
                )
            ),
            TrendingCoinItem(
                id: "nkn",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "nkn",
                    coinId: 3375,
                    name: "NKN",
                    symbol: "NKN",
                    marketCapRank: 753,
                    small: "https://coin-images.coingecko.com/coins/images/3375/small/nkn.png?1696504074",
                    score: 3,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.04799110191485709,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 123.31775790330973)
                    )
                )
            ),
            TrendingCoinItem(
                id: "solana",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "solana",
                    coinId: 4128,
                    name: "Solana",
                    symbol: "SOL",
                    marketCapRank: 6,
                    small: "https://coin-images.coingecko.com/coins/images/4128/small/solana.png?1718769756",
                    score: 4,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 141.300899579125,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 2.005562613407555)
                    )
                )
            ),
            TrendingCoinItem(
                id: "hyperliquid",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "hyperliquid",
                    coinId: 50882,
                    name: "Hyperliquid",
                    symbol: "HYPE",
                    marketCapRank: 24,
                    small: "https://coin-images.coingecko.com/coins/images/50882/small/hyperliquid.jpg?1729431300",
                    score: 5,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 18.388523322751112,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 4.648785292875282)
                    )
                )
            ),
            TrendingCoinItem(
                id: "bittensor",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "bittensor",
                    coinId: 28452,
                    name: "Bittensor",
                    symbol: "TAO",
                    marketCapRank: 45,
                    small: "https://coin-images.coingecko.com/coins/images/28452/small/ARUsPeNQ_400x400.jpeg?1696527447",
                    score: 6,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 299.12281910185965,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 8.424186156824213)
                    )
                )
            ),
            TrendingCoinItem(
                id: "pi-network",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "pi-network",
                    coinId: 54342,
                    name: "Pi Network",
                    symbol: "PI",
                    marketCapRank: 30,
                    small: "https://coin-images.coingecko.com/coins/images/54342/small/pi_network.jpg?1739347576",
                    score: 7,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.6510938381227491,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 0.14435414703995836)
                    )
                )
            ),
            TrendingCoinItem(
                id: "fartcoin",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "fartcoin",
                    coinId: 50891,
                    name: "Fartcoin",
                    symbol: "FARTCOIN",
                    marketCapRank: 90,
                    small: "https://coin-images.coingecko.com/coins/images/50891/small/fart.jpg?1729503972",
                    score: 8,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.869785888405358,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 10.712376220720815)
                    )
                )
            ),
            TrendingCoinItem(
                id: "ondo-finance",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "ondo-finance",
                    coinId: 26580,
                    name: "Ondo",
                    symbol: "ONDO",
                    marketCapRank: 42,
                    small: "https://coin-images.coingecko.com/coins/images/26580/small/ONDO.png?1696525656",
                    score: 9,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.855796732816021,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 1.3320226338453656)
                    )
                )
            ),
            TrendingCoinItem(
                id: "sui",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "sui",
                    coinId: 26375,
                    name: "Sui",
                    symbol: "SUI",
                    marketCapRank: 20,
                    small: "https://coin-images.coingecko.com/coins/images/26375/small/sui-ocean-square.png?1727791290",
                    score: 10,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 2.1646565148870347,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 0.8360855939596146)
                    )
                )
            ),
            TrendingCoinItem(
                id: "magic",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "magic",
                    coinId: 18623,
                    name: "Treasure",
                    symbol: "MAGIC",
                    marketCapRank: 701,
                    small: "https://coin-images.coingecko.com/coins/images/18623/small/magic.png?1696518095",
                    score: 11,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.1361537785648643,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 72.79609793944464)
                    )
                )
            ),
            TrendingCoinItem(
                id: "bitcoin",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "bitcoin",
                    coinId: 1,
                    name: "Bitcoin",
                    symbol: "BTC",
                    marketCapRank: 1,
                    small: "https://coin-images.coingecko.com/coins/images/1/small/bitcoin.png?1696501400",
                    score: 12,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 85200.21976367784,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 0.15640170979841742)
                    )
                )
            ),
            TrendingCoinItem(
                id: "aerodrome-finance",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "aerodrome-finance",
                    coinId: 31745,
                    name: "Aerodrome Finance",
                    symbol: "AERO",
                    marketCapRank: 188,
                    small: "https://coin-images.coingecko.com/coins/images/31745/small/token.png?1696530564",
                    score: 13,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.4085395571516313,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 4.181348796789184)
                    )
                )
            ),
            TrendingCoinItem(
                id: "dogwifcoin",
                item: Trending.TrendingCoinItem.TrendingCoinDetails(
                    id: "dogwifcoin",
                    coinId: 33566,
                    name: "dogwifhat",
                    symbol: "WIF",
                    marketCapRank: 148,
                    small: "https://coin-images.coingecko.com/coins/images/33566/small/dogwifhat.jpg?1702499428",
                    score: 14,
                    data: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData(
                        price: 0.43541615332531963,
                        priceChangePercentage24h: Trending.TrendingCoinItem.TrendingCoinDetails.TrendingCoinData.Percentage(usd: 7.089150734125139)
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
                floorPrice24hPercentageChange: 43.40048103638284,
                data: Trending.TrendingNFTItem.TrendingNFTData(floorPrice: "0.40 ETH")
            ),
            TrendingNFTItem(
                id: "cryptodickbutts",
                name: "CryptoDickbutts",
                symbol: "CDB",
                thumb: "https://coin-images.coingecko.com/nft_contracts/images/1265/standard/cryptodickbutts.gif?1707287730",
                floorPrice24hPercentageChange: 34.41340146244138,
                data: Trending.TrendingNFTItem.TrendingNFTData(floorPrice: "0.78 ETH")
            ),
            TrendingNFTItem(
                id: "opepen-edition",
                name: "Opepen Edition",
                symbol: "OPEPEN",
                thumb: "https://coin-images.coingecko.com/nft_contracts/images/2540/standard/opepen.jpeg?1707288408",
                floorPrice24hPercentageChange: 21.83147839304141,
                data: Trending.TrendingNFTItem.TrendingNFTData(floorPrice: "0.29 ETH")
            ),
            TrendingNFTItem(
                id: "cryptopunks-v1-wrapped",
                name: "CryptoPunks V1 (wrapped)",
                symbol: "WPV1",
                thumb: "https://coin-images.coingecko.com/nft_contracts/images/479/standard/cryptopunks-v1-wrapped.png?1707287336",
                floorPrice24hPercentageChange: 19.37131425180619,
                data: Trending.TrendingNFTItem.TrendingNFTData(floorPrice: "2.49 ETH")
            ),
            TrendingNFTItem(
                id: "bored-ape-kennel-club",
                name: "Bored Ape Kennel Club",
                symbol: "bakc",
                thumb: "https://coin-images.coingecko.com/nft_contracts/images/233/standard/bored-ape-kennel-club.png?1707287231",
                floorPrice24hPercentageChange: 11.21229795899199,
                data: Trending.TrendingNFTItem.TrendingNFTData(floorPrice: "0.65 ETH")
            ),
            TrendingNFTItem(
                id: "wealthy-hypio-babies",
                name: "Wealthy Hypio Babies",
                symbol: "hypio",
                thumb: "https://coin-images.coingecko.com/nft_contracts/images/15671/standard/wealthy-hypio-babies.png?1741099389",
                floorPrice24hPercentageChange: 9.86999323987863,
                data: Trending.TrendingNFTItem.TrendingNFTData(floorPrice: "1.80 ETH")
            ),
            TrendingNFTItem(
                id: "redacted-remilio-babies",
                name: "Redacted Remilio Babies",
                symbol: "TEST",
                thumb: "https://coin-images.coingecko.com/nft_contracts/images/2736/standard/redacted-remilio-babies.?1707289665",
                floorPrice24hPercentageChange: 7.488478262947211,
                data: Trending.TrendingNFTItem.TrendingNFTData(floorPrice: "0.53 ETH")
            )
        ]
    )
}
