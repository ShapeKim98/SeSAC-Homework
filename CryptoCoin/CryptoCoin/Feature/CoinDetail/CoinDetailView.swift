//
//  CoinDetailView.swift
//  CryptoCoin
//
//  Created by 김도형 on 4/20/25.
//

import SwiftUI
import UIKit

import Dependencies
import DGCharts

struct CoinDetailView: View {
    @Dependency(CoinGeckoClient.self)
    private var client
    
    @State
    private var coin: CoinDetail = .mock
    @State
    private var isLoading = true
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    var body: some View {
        ScrollView(content: content)
            .task(bodyTask)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
    }
}

// MARK: - Configure Views
private extension CoinDetailView {
    func content() -> some View {
        VStack(alignment: .leading, spacing: 32) {
            title
            
            price
            
            infoSection
            
            let prices = isLoading ? [] : (coin.sparklineIn7d?.price ?? [])
            CoinChart(prices: prices)
                .frame(maxWidth: .infinity)
                .frame(height: 400)
        }
        .redacted(reason: isLoading ? [.placeholder] : [])
        .animation(.smooth, value: isLoading)
        .padding(.horizontal, 16)
    }
    
    var title: some View {
        HStack(spacing: 4) {
            AsyncImage(url: URL(string: coin.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.secondary
                @unknown default:
                    Color.secondary
                }
            }
            .frame(width: 40, height: 40)
            .clipped()
            
            Text(coin.name)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var price: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("₩\(coin.currentPrice.formatted())")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 8) {
                let percentage = coin.priceChangePercentage24h ?? 0
                let color: Color = percentage > 0
                ? .red : percentage < 0
                ? .blue : .primary
                let format = percentage > 0 ? "+%.2f" : "%.2f"
                
                Text("\(String(format: format, percentage))%")
                    .font(.footnote)
                    .foregroundStyle(color)
                
                Text("Today")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var infoSection: some View {
        HStack(spacing: 80) {
            VStack(alignment: .leading, spacing: 20) {
                InfoCell(
                    title: "고가",
                    price: coin.high24h ?? 0,
                    isHigh: true
                )
                
                InfoCell(
                    title: "신고점",
                    price: coin.ath,
                    isHigh: true
                )
            }
            
            VStack(alignment: .leading, spacing: 20) {
                InfoCell(
                    title: "저가",
                    price: coin.low24h ?? 0,
                    isHigh: false
                )
                
                InfoCell(
                    title: "신저점",
                    price: coin.atl,
                    isHigh: false
                )
            }
        }
    }
    
    struct InfoCell: View {
        private let title: String
        private let price: Double
        private let isHigh: Bool
        
        init(
            title: String,
            price: Double,
            isHigh: Bool
        ) {
            self.title = title
            self.price = price
            self.isHigh = isHigh
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(isHigh ? .red : .blue)
                
                Text("₩" + price.formatted())
                    .font(.subheadline)
            }
        }
    }
    
    struct CoinChart: UIViewRepresentable {
        private let prices: [Double]
        
        init(prices: [Double]) {
            self.prices = prices
        }
        
        func makeUIView(context: Context) -> LineChartView {
            let lineChartView = LineChartView()
            lineChartView.backgroundColor = .clear
            
            lineChartView.xAxis.drawAxisLineEnabled = false
            lineChartView.xAxis.drawGridLinesEnabled = false
            lineChartView.xAxis.drawLabelsEnabled = false
            
            lineChartView.leftAxis.drawLabelsEnabled = false
            lineChartView.leftAxis.drawGridLinesEnabled = false
            lineChartView.leftAxis.drawAxisLineEnabled = false
        
            lineChartView.rightAxis.drawGridLinesEnabled = false
            lineChartView.rightAxis.drawLabelsEnabled = false
            lineChartView.rightAxis.drawAxisLineEnabled = false
            
            lineChartView.dragEnabled = false
            lineChartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
            lineChartView.legend.enabled = false
            lineChartView.animate(xAxisDuration: 1, easingOption: .easeOutSine)
            
            return lineChartView
        }
        
        func updateUIView(_ uiView: LineChartView, context: Context) {
            uiView.data = updateDataSet()
        }
        
        private func updateDataSet() -> LineChartData? {
            let values = prices.enumerated().compactMap { index, value in
                return ChartDataEntry(x: Double(index), y: value)
            }
            let dataSet = LineChartDataSet(entries: values)
            dataSet.colors = [NSUIColor(cgColor: UIColor(.purple).cgColor)]
            dataSet.mode = .cubicBezier
            dataSet.drawFilledEnabled = true
            dataSet.drawCirclesEnabled = false
            dataSet.drawValuesEnabled = false
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [
                    UIColor(.purple).cgColor,
                    UIColor(.purple.opacity(0.1)).cgColor
                ] as CFArray ,
                locations: [0.7, 0.0]
            )
            guard let gradient else { return nil }
            dataSet.fill = LinearGradientFill(
                gradient: gradient,
                angle: 90
            )
            dataSet.lineWidth = 2
            return LineChartData(dataSet: dataSet)
        }
    }
}

// MARK: - Functions
private extension CoinDetailView {
    @Sendable
    func bodyTask() async {
        do {
            let request = CoinDetailRequest(ids: id)
            let response = try await client.fetchCoinDetail(request).first
            guard let response else { return }
            coin = response
            isLoading = false
        } catch {
            print(error)
        }
    }
}

#Preview {
    NavigationStack {
        CoinDetailView(id: "bitcoin")
    }
}
