//
//  MissionView.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/14/25.
//

import SwiftUI

struct MissionView: View {
    private let missionList: [Mission] = .sample
    private let ad = Mission(
        title: "[70,000원] 가입 지원금" ,
        subtitle: "빗썸 가입하고 미수령 지원금 받기 • AD",
        image: "bell.square.fill"
    )
    
    var body: some View {
        ScrollView(content: content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .preferredColorScheme(.dark)
    }
    
    private func content() -> some View {
        VStack(spacing: 16) {
            adSection
            
            missionSection
        }
    }
    
    private var adSection: some View {
        MissionCell(mission: ad, isAD: true)
            .tsBackground()
    }
    
    private var missionSection: some View {
        VStack(spacing: 32) {
            ForEach(missionList) { mission in
                MissionCell(mission: mission)
            }
        }
        .tsBackground()
    }
}

private struct MissionCell: View {
    let mission: Mission
    let isAD: Bool

    
    init(mission: Mission, isAD: Bool = false) {
        self.mission = mission
        self.isAD = isAD
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .foregroundStyle(.secondary.opacity(0.4))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: mission.image)
                        .foregroundStyle(.white)
                }
            
            content
            
            Spacer()
            
            if mission.isNew {
                newTag
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(mission.title)
                .font(.headline)
                .foregroundStyle(.white)
            
            if isAD {
                Text(mission.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text(mission.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
        }
    }
    
    private var newTag: some View {
        Text("새로 나온")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(.secondary.opacity(0.5))
            .clipShape(RoundedRectangle(
                cornerRadius: 9999,
                style: .continuous
            ))
            .clipped()
    }
}



#Preview {
    MissionView()
}
