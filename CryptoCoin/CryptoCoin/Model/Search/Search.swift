//
//  서치데이터.swift
//  Dobong_Crypto
//
//  Created by Bran on 3/7/25.
//

import Foundation

struct Search: Decodable, Hashable {
    let coins: [SearchItem]
    let nfts: [SearchItem]
}

/// #3. Crypto Search 화면
extension Search {
    struct SearchItem: Hashable, Identifiable, Decodable {
        let id: String
        let name: String
        let symbol: String
        let marketCapRank: Int?
        let thumb: String
        let large: String?
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        enum CodingKeys: String, CodingKey {
            case id, name, symbol, thumb, large
            case marketCapRank = "market_cap_rank"
        }
    }
}
extension Search {
    static var mock: Search {
        Search(
            coins: [
                SearchItem(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    marketCapRank: 1,
                    thumb: "https://coin-images.coingecko.com/coins/images/1/thumb/bitcoin.png",
                    large: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png"
                ),
                SearchItem(
                    id: "wrapped-bitcoin",
                    name: "Wrapped Bitcoin",
                    symbol: "WBTC",
                    marketCapRank: 12,
                    thumb: "https://coin-images.coingecko.com/coins/images/7598/thumb/wrapped_bitcoin_wbtc.png",
                    large: "https://coin-images.coingecko.com/coins/images/7598/large/wrapped_bitcoin_wbtc.png"
                ),
                SearchItem(
                    id: "bitcoin-cash",
                    name: "Bitcoin Cash",
                    symbol: "BCH",
                    marketCapRank: 23,
                    thumb: "https://coin-images.coingecko.com/coins/images/780/thumb/bitcoin-cash-circle.png",
                    large: "https://coin-images.coingecko.com/coins/images/780/large/bitcoin-cash-circle.png"
                ),
                SearchItem(
                    id: "bitget-token",
                    name: "Bitget Token",
                    symbol: "BGB",
                    marketCapRank: 27,
                    thumb: "https://coin-images.coingecko.com/coins/images/11610/thumb/Bitget_logo.png",
                    large: "https://coin-images.coingecko.com/coins/images/11610/large/Bitget_logo.png"
                ),
                SearchItem(
                    id: "whitebit",
                    name: "WhiteBIT Coin",
                    symbol: "WBT",
                    marketCapRank: 33,
                    thumb: "https://coin-images.coingecko.com/coins/images/27045/thumb/wbt_token.png",
                    large: "https://coin-images.coingecko.com/coins/images/27045/large/wbt_token.png"
                ),
                SearchItem(
                    id: "bittensor",
                    name: "Bittensor",
                    symbol: "TAO",
                    marketCapRank: 45,
                    thumb: "https://coin-images.coingecko.com/coins/images/28452/thumb/ARUsPeNQ_400x400.jpeg",
                    large: "https://coin-images.coingecko.com/coins/images/28452/large/ARUsPeNQ_400x400.jpeg"
                ),
                SearchItem(
                    id: "arbitrum",
                    name: "Arbitrum",
                    symbol: "ARB",
                    marketCapRank: 70,
                    thumb: "https://coin-images.coingecko.com/coins/images/16547/thumb/arb.jpg",
                    large: "https://coin-images.coingecko.com/coins/images/16547/large/arb.jpg"
                ),
                SearchItem(
                    id: "arbitrum-bridged-wbtc-arbitrum-one",
                    name: "Arbitrum Bridged WBTC (Arbitrum One)",
                    symbol: "WBTC",
                    marketCapRank: 105,
                    thumb: "https://coin-images.coingecko.com/coins/images/39532/thumb/wbtc.png",
                    large: "https://coin-images.coingecko.com/coins/images/39532/large/wbtc.png"
                ),
                SearchItem(
                    id: "bittorrent",
                    name: "BitTorrent",
                    symbol: "BTT",
                    marketCapRank: 121,
                    thumb: "https://coin-images.coingecko.com/coins/images/22457/thumb/btt_logo.png",
                    large: "https://coin-images.coingecko.com/coins/images/22457/large/btt_logo.png"
                ),
                SearchItem(
                    id: "bitcoin-cash-sv",
                    name: "Bitcoin SV",
                    symbol: "BSV",
                    marketCapRank: 126,
                    thumb: "https://coin-images.coingecko.com/coins/images/6799/thumb/BSV.png",
                    large: "https://coin-images.coingecko.com/coins/images/6799/large/BSV.png"
                ),
                SearchItem(
                    id: "arbitrum-bridged-weth-arbitrum-one",
                    name: "Arbitrum Bridged WETH (Arbitrum One)",
                    symbol: "WETH",
                    marketCapRank: 181,
                    thumb: "https://coin-images.coingecko.com/coins/images/39713/thumb/WETH.PNG",
                    large: "https://coin-images.coingecko.com/coins/images/39713/large/WETH.PNG"
                ),
                SearchItem(
                    id: "bybit-staked-sol",
                    name: "Bybit Staked SOL",
                    symbol: "BBSOL",
                    marketCapRank: 273,
                    thumb: "https://coin-images.coingecko.com/coins/images/40095/thumb/400x400.png",
                    large: "https://coin-images.coingecko.com/coins/images/40095/large/400x400.png"
                ),
                SearchItem(
                    id: "dog-go-to-the-moon-rune",
                    name: "Dog (Bitcoin)",
                    symbol: "DOG",
                    marketCapRank: 324,
                    thumb: "https://coin-images.coingecko.com/coins/images/37352/thumb/DOGGOTOTHEMOON.png",
                    large: "https://coin-images.coingecko.com/coins/images/37352/large/DOGGOTOTHEMOON.png"
                ),
                SearchItem(
                    id: "rollbit-coin",
                    name: "Rollbit Coin",
                    symbol: "RLB",
                    marketCapRank: 332,
                    thumb: "https://coin-images.coingecko.com/coins/images/24552/thumb/unziL6wO_400x400.jpg",
                    large: "https://coin-images.coingecko.com/coins/images/24552/large/unziL6wO_400x400.jpg"
                ),
                SearchItem(
                    id: "usd-coin-ethereum-bridged",
                    name: "Arbitrum Bridged USDC (Arbitrum)",
                    symbol: "USDC.E",
                    marketCapRank: 398,
                    thumb: "https://coin-images.coingecko.com/coins/images/30691/thumb/usdc.png",
                    large: "https://coin-images.coingecko.com/coins/images/30691/large/usdc.png"
                ),
                SearchItem(
                    id: "bitdca",
                    name: "BitDCA",
                    symbol: "BDCA",
                    marketCapRank: 405,
                    thumb: "https://coin-images.coingecko.com/coins/images/54590/thumb/bdca_logo_transparent200x200.png",
                    large: "https://coin-images.coingecko.com/coins/images/54590/large/bdca_logo_transparent200x200.png"
                ),
                SearchItem(
                    id: "gamebitcoin-power",
                    name: "Gamebitcoin Power",
                    symbol: "PWR",
                    marketCapRank: 452,
                    thumb: "https://coin-images.coingecko.com/coins/images/53262/thumb/pwr_200x200.png",
                    large: "https://coin-images.coingecko.com/coins/images/53262/large/pwr_200x200.png"
                ),
                SearchItem(
                    id: "bitmart-token",
                    name: "BitMart",
                    symbol: "BMX",
                    marketCapRank: 460,
                    thumb: "https://coin-images.coingecko.com/coins/images/5236/thumb/bitmart-token.png",
                    large: "https://coin-images.coingecko.com/coins/images/5236/large/bitmart-token.png"
                ),
                SearchItem(
                    id: "bit2me",
                    name: "Bit2Me",
                    symbol: "B2M",
                    marketCapRank: 556,
                    thumb: "https://coin-images.coingecko.com/coins/images/19848/thumb/b2m-circle-solid-default.png",
                    large: "https://coin-images.coingecko.com/coins/images/19848/large/b2m-circle-solid-default.png"
                ),
                SearchItem(
                    id: "magic-internet-money-runes",
                    name: "MAGIC•INTERNET•MONEY (Bitcoin)",
                    symbol: "MIM",
                    marketCapRank: 592,
                    thumb: "https://coin-images.coingecko.com/coins/images/54456/thumb/MIM_LOGO_2.png",
                    large: "https://coin-images.coingecko.com/coins/images/54456/large/MIM_LOGO_2.png"
                ),
                SearchItem(
                    id: "harrypotterobamasonic10in",
                    name: "HarryPotterObamaSonic10Inu (ETH)",
                    symbol: "BITCOIN",
                    marketCapRank: 658,
                    thumb: "https://coin-images.coingecko.com/coins/images/30323/thumb/hpos10i_logo_casino_night-dexview.png",
                    large: "https://coin-images.coingecko.com/coins/images/30323/large/hpos10i_logo_casino_night-dexview.png"
                ),
                SearchItem(
                    id: "bouncebit",
                    name: "BounceBit",
                    symbol: "BB",
                    marketCapRank: 682,
                    thumb: "https://coin-images.coingecko.com/coins/images/37144/thumb/bb.jpeg",
                    large: "https://coin-images.coingecko.com/coins/images/37144/large/bb.jpeg"
                ),
                SearchItem(
                    id: "bitcoin-wizards",
                    name: "Bitcoin Wizards",
                    symbol: "WZRD",
                    marketCapRank: 687,
                    thumb: "https://coin-images.coingecko.com/coins/images/33425/thumb/78e454a7f80334c3e2ac89a314e79e0.jpg",
                    large: "https://coin-images.coingecko.com/coins/images/33425/large/78e454a7f80334c3e2ac89a314e79e0.jpg"
                ),
                SearchItem(
                    id: "orbiter-finance",
                    name: "Orbiter Finance",
                    symbol: "OBT",
                    marketCapRank: 837,
                    thumb: "https://coin-images.coingecko.com/coins/images/53783/thumb/orbiter.jpg",
                    large: "https://coin-images.coingecko.com/coins/images/53783/large/orbiter.jpg"
                ),
                SearchItem(
                    id: "moonrabbits",
                    name: "MoonRabbits",
                    symbol: "MRB",
                    marketCapRank: 864,
                    thumb: "https://coin-images.coingecko.com/coins/images/52273/thumb/MoonRabbits_icon_resized.png",
                    large: "https://coin-images.coingecko.com/coins/images/52273/large/MoonRabbits_icon_resized.png"
                )
            ],
            nfts: [
                SearchItem(
                    id: "bit-bears-by-berachain",
                    name: "Bit Bears by Berachain",
                    symbol: "BITB",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2114/thumb/bit-bears-by-berachain.png",
                    large: nil
                ),
                SearchItem(
                    id: "bit-kids",
                    name: "Bit Kids",
                    symbol: "BIT KIDS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3921/thumb/bit-kids.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcanna-buddheads",
                    name: "BitCanna Buddheads",
                    symbol: "BITCANNA BUDDHEADS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4349/thumb/Screenshot_2024-05-03_064011.png",
                    large: nil
                ),
                SearchItem(
                    id: "meebits",
                    name: "Meebits",
                    symbol: "⚇",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/28/thumb/meebits.png",
                    large: nil
                ),
                SearchItem(
                    id: "orbit-by-jiannan-huang",
                    name: "Orbit By Jiannan Huang",
                    symbol: "ORBIT",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4533/thumb/orbit-by-jiannan-huang.png",
                    large: nil
                ),
                SearchItem(
                    id: "rabbit-planet",
                    name: "Rabbit Planet",
                    symbol: "RABBIT PLANET",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2488/thumb/rabbit-planet.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-frogs",
                    name: "Bitcoin Frogs",
                    symbol: "BITCOIN-FROGS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3262/thumb/bitcoin-frogs.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitmap",
                    name: "bitmap",
                    symbol: "BITMAP",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3255/thumb/bitmap.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-eternals",
                    name: "Bitcoin Eternals",
                    symbol: "BITCOINETERNALS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15741/thumb/bitcoin-eternals.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-puppets",
                    name: "Bitcoin Puppets",
                    symbol: "BITCOIN-PUPPETS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3873/thumb/bitcoin-puppets.png",
                    large: nil
                ),
                SearchItem(
                    id: "killabits",
                    name: "KILLABITS",
                    symbol: "KILLABITS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2210/thumb/killabits.png",
                    large: nil
                ),
                SearchItem(
                    id: "punkbits",
                    name: "PUNKBITS",
                    symbol: "PNKBTS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3917/thumb/punkbits.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-boos-boottalion",
                    name: "Bitcoin Boos: Boottalion",
                    symbol: "BOOTTALION",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4045/thumb/bitcoin-boos-boottalion.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-mfers",
                    name: "Bitcoin mfers",
                    symbol: "BITCOIN-MFERS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4302/thumb/bitcoin-mfers.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-crypto-dickbutts",
                    name: "Bitcoin Crypto DickButts",
                    symbol: "BITCOIN-CRYPTODICKBUTTS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3656/thumb/bitcoin-crypto-dickbutts.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitboy-one-genesis",
                    name: "BitBoy One Genesis",
                    symbol: "BITBOY_ONE_GENESIS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4438/thumb/bitboy-one-genesis.gif",
                    large: nil
                ),
                SearchItem(
                    id: "eightbit-me",
                    name: "EightBit Me",
                    symbol: "BIT",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/548/thumb/eightbit-me.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-is",
                    name: "Bitcoin Is",
                    symbol: "BITCOIN-IS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15399/thumb/bitcoin-is.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-frugs",
                    name: "Bitcoin Frugs",
                    symbol: "BTC-FRUGS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15369/thumb/bitcoin-frugs.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "playboy-rabbitars-official",
                    name: "Playboy Rabbitars Official",
                    symbol: "PLAY",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/501/thumb/playboy-rabbitars-official.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-trumps",
                    name: "Bitcoin Trumps",
                    symbol: "BITCOINTRUMPS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4046/thumb/bitcoin-trumps.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-bandits",
                    name: "Bitcoin Bandits",
                    symbol: "BITCOIN-BANDITS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3266/thumb/bitcoin-bandits.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitdogs",
                    name: "Bitdogs",
                    symbol: "BITDOGS_BTC",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4451/thumb/bitdogs.png",
                    large: nil
                ),
                SearchItem(
                    id: "zbit-loot-box",
                    name: "ZBIT Loot Box",
                    symbol: "ZBIT-LOOT-BOX",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4675/thumb/zbit-loot-box.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-pills",
                    name: "Bitcoin Pills",
                    symbol: "BITCOIN-PILLS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15347/thumb/btcpills.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-bear-cubs",
                    name: "Bitcoin Bear Cubs",
                    symbol: "BBC",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3280/thumb/bitcoin-bear-cubs.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-wizards",
                    name: "Bitcoin Wizards",
                    symbol: "BITCOIN-WIZARDS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3683/thumb/wizards.png",
                    large: nil
                ),
                SearchItem(
                    id: "dog-genesis",
                    name: "$DOG | Genesis ",
                    symbol: "DOG_OF_BITCOIN",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15299/thumb/dog-genesis.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "ponzis",
                    name: "Ponzis",
                    symbol: "BITCOINPONZIS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15685/thumb/ponzis.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitmaps-by-oto",
                    name: "Bitmaps by OTO",
                    symbol: "BITMAPS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3314/thumb/bitmaps-by-oto.gif",
                    large: nil
                ),
                SearchItem(
                    id: "bitglyphs",
                    name: "BitGlyphs",
                    symbol: "BITGLYPHS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/14972/thumb/bitglyphs.png",
                    large: nil
                ),
                SearchItem(
                    id: "taproot-bitches",
                    name: "Taproot Bitches",
                    symbol: "TAPROOTBITCHES",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15030/thumb/taproot.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-shrooms",
                    name: "Bitcoin Shrooms",
                    symbol: "BITCOINSHROOMS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4161/thumb/bitcoin-shrooms.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "trump-bitcoin-digital-trading-cards",
                    name: "Trump Bitcoin Digital Trading Cards",
                    symbol: "TRUMP-BITCOIN-TRADING-CARDS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15370/thumb/trump-bitcoin-digital-trading-cards.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-punks",
                    name: "Bitcoin Punks",
                    symbol: "BITCOIN-PUNKS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3259/thumb/bitcoin-punks.png",
                    large: nil
                ),
                SearchItem(
                    id: "jeets-on-bitcoin",
                    name: "Jeets On Bitcoin",
                    symbol: "JEETSONBTC",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15700/thumb/jeets-on-bitcoin.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-rugs",
                    name: "Bitcoin Rugs",
                    symbol: "BITCOINRUGS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3313/thumb/bitcoin-rugs.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-babbies",
                    name: "BITCOIN BABBIES",
                    symbol: "BTCBABBIES",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4181/thumb/bitcoin-babbies.gif",
                    large: nil
                ),
                SearchItem(
                    id: "genesis-genopets-habitats",
                    name: "Genesis Genopets Habitats",
                    symbol: "GENPETSHAB",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2661/thumb/genesis-genopets-habitats.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "bitmappunks",
                    name: "BitmapPunks",
                    symbol: "BMP",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15733/thumb/bitmappunks.png",
                    large: nil
                ),
                SearchItem(
                    id: "bit-bears",
                    name: "Bit Bears",
                    symbol: "BITB",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15571/thumb/bit-bears.gif",
                    large: nil
                ),
                SearchItem(
                    id: "bitbeast",
                    name: "BITBEAST",
                    symbol: "BIT",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3818/thumb/bitbeast.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitch-better-have-my-money-by-rihanna-anotherblock",
                    name: "Bitch Better Have My Money",
                    symbol: "DROP5",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2956/thumb/bitch-better-have-my-money-by-rihanna-anotherblock.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-whales",
                    name: "Bitcoin Whales",
                    symbol: "BITCOINWHALES",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3269/thumb/bitcoin-whales.png",
                    large: nil
                ),
                SearchItem(
                    id: "the-golden-horseshoe-by-bitcoin-derby",
                    name: "The Golden Horseshoe By Bitcoin Derby",
                    symbol: "THE_GOLDEN_HORSESHOE",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15664/thumb/the-golden-horseshoe-by-bitcoin-derby.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoinbearclub",
                    name: "Bitcoin Bear Club",
                    symbol: "BBC",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/1284/thumb/unnamed.gif",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-puppets-honoraries",
                    name: "Bitcoin Puppets Honoraries",
                    symbol: "BITCOIN-PUPPETS-HONORARIES",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15069/thumb/bitcoin-puppets-honoraries.png",
                    large: nil
                ),
                SearchItem(
                    id: "hitobito-reverse",
                    name: "Hitobito Reverse",
                    symbol: "HITOBITO REVERSE",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3983/thumb/hitobito-reverse.png",
                    large: nil
                ),
                SearchItem(
                    id: "mad-rabbits-riot-club",
                    name: "Mad Rabbits Riot Club",
                    symbol: "MRRC",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/613/thumb/mad-rabbits-riot-club.png",
                    large: nil
                ),
                SearchItem(
                    id: "orbitflare-pass",
                    name: "OrbitFlare Pass",
                    symbol: "ORBITFLARE",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4803/thumb/obp.png",
                    large: nil
                ),
                SearchItem(
                    id: "ragnarok-meta",
                    name: "77-Bit",
                    symbol: "RONIN",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/365/thumb/77-bit.png",
                    large: nil
                ),
                SearchItem(
                    id: "elementerra-rabbits",
                    name: "Elementerra Rabbits",
                    symbol: "ELE",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/4049/thumb/elementerra-rabbits.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-pandas",
                    name: "Bitcoin Pandas",
                    symbol: "BITCOIN-PANDAS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3365/thumb/bitcoin-pandas.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-burials",
                    name: "Bitcoin Burials",
                    symbol: "BITCOINBURIALS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3863/thumb/BURY.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-mechanics",
                    name: "Bitcoin Mechanics",
                    symbol: "BTC_MECHANICS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3306/thumb/bitcoin-mechanics.png",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-buds",
                    name: "Bitcoin Buds ",
                    symbol: "BITCOIN-BUDS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3285/thumb/bitcoin-buds.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "arbitrum-odyssey",
                    name: "Arbitrum Odyssey NFT",
                    symbol: "ARBITRUM",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/1822/thumb/https-fanbase-1-s3-amazonaws-com-quixotic-collection-profile-046qixwt_400x400-jpeg.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-pigs",
                    name: "Bitcoin Pigs",
                    symbol: "BITCOINPIGS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3355/thumb/bitcoin-pigs.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "memecards",
                    name: "MemeCards",
                    symbol: "RIBBIT",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15227/thumb/memecards.gif",
                    large: nil
                ),
                SearchItem(
                    id: "freebit-slimes",
                    name: "FreeBit - Slimes",
                    symbol: "FREEBIT - SLIMES",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3934/thumb/freebit-slimes.jpeg",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoinorb",
                    name: "BITCOINORB",
                    symbol: "BTCORB",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/2944/thumb/bitcoinorb.png",
                    large: nil
                ),
                SearchItem(
                    id: "abstract-rabbits",
                    name: "Abstract Rabbits",
                    symbol: "RABBITS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15561/thumb/abstract-rabbits.png",
                    large: nil
                ),
                SearchItem(
                    id: "bit-pixels",
                    name: "Bit pixels",
                    symbol: "BERPIX",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15623/thumb/bit-pixels.gif",
                    large: nil
                ),
                SearchItem(
                    id: "bitcoin-gizmos",
                    name: "Bitcoin Gizmos",
                    symbol: "BITCOINGIZMOS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15066/thumb/bitcoin-gizmos.png",
                    large: nil
                ),
                SearchItem(
                    id: "bit-apes-by-bayc-members",
                    name: "BIT APES by BAYC Members",
                    symbol: "BITAPES",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3274/thumb/bit-apes-by-bayc-members.png",
                    large: nil
                ),
                SearchItem(
                    id: "cursed-bitcoin-punks",
                    name: "Cursed Bitcoin Punks",
                    symbol: "CURSEDBITCOINPUNKS",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3311/thumb/cursed-bitcoin-punks.png",
                    large: nil
                ),
                SearchItem(
                    id: "metahero",
                    name: "Inhabitants: Generative Identities",
                    symbol: "HERO",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/132/thumb/HERO.jpg",
                    large: nil
                ),
                SearchItem(
                    id: "hitobito",
                    name: "Hitobito",
                    symbol: "HITOBITO",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3974/thumb/hitobito.gif",
                    large: nil
                ),
                SearchItem(
                    id: "ribbitstract",
                    name: "Ribbitstract",
                    symbol: "RIBBIT",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/15510/thumb/ribbitstract.gif",
                    large: nil
                ),
                SearchItem(
                    id: "right-place-right-time-bitcoin-volatility-art-by-matt-kane",
                    name: "Right Place & Right Time - Bitcoin Volatility Art",
                    symbol: "VLY",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/3530/thumb/right-place-right-time-bitcoin-volatility-art-by-matt-kane.png",
                    large: nil
                ),
                SearchItem(
                    id: "metahero-universe-united-planets",
                    name: "Inhabitants: United Planets",
                    symbol: "PLANET",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/532/thumb/metahero-universe-united-planets.png",
                    large: nil
                ),
                SearchItem(
                    id: "openseaonarbitrum",
                    name: "OpenSea Arbitrum by Layer2DAO",
                    symbol: "OPENSEAARB",
                    marketCapRank: nil,
                    thumb: "https://coin-images.coingecko.com/nft_contracts/images/1840/thumb/https-fanbase-1-s3-amazonaws-com-quixotic-collection-profile-1_kba2odb-png.png",
                    large: nil
                )
            ]
        )
    }
}
