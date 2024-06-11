//
//  TempView.swift
//  DuriMeal
//
//  Created by namdghyun on 5/4/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var scheme
    @StateObject var vm = MainViewModel()
    
    var body: some View {
        ZStack {
            Theme.myBackgroundColor(forSchme: scheme)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 18) {
                HeaderButton(vm: vm)
//                WeeklyButton()
                subPlace()
                ScrollView {
                    ForEach(vm.times, id: \.self) { time in
                        ShowMenu(vm: vm, time: time, meals: vm.filteredMeals(for: time))
                    }
                }
                .scrollIndicators(.never)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func subPlace() -> some View {
        if vm.selectedPlace.needSubplace() {
            HStack {
                Menu {
                    ForEach(vm.selectedPlace.returnSubplace(), id: \.self) { sub in
                        Button {
                            withAnimation(.bouncy) {
                                vm.selectedSubPlace = sub
                            }
                        } label: { Label(sub, systemImage: sub.subToIcon()) }
                    }
                } label: {
                    HStack {
                        Text(vm.selectedSubPlace).font(.title2).bold()
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
                Spacer()
            }
        }
    }
}

fileprivate struct WeeklyButton: View {
    @State var selected: Bool = false
    let days: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                Spacer()
                Text("\(day)")
                Spacer()
            }
        }
        .padding(-5)
    }
}

fileprivate struct HeaderButton: View {
    @ObservedObject var vm: MainViewModel
    @ScaledMetric(relativeTo: .title2) var dynamicHeight = 30
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vm.places, id: \.self) { place in
                    PlaceButton(vm: vm, place: place)
                    if vm.places.last != place {
                        Rectangle()
                            .frame(width: 2)
                            .foregroundStyle(.primary.opacity(0.2))
                            .padding(.vertical, 5)
                    }
                }
            }
            .frame(maxHeight: dynamicHeight)
        }
    }
}

fileprivate struct PlaceButton: View {
    @ObservedObject var vm: MainViewModel
    let place: Place
    let notSelectedColor: Color = .secondary.opacity(0.5)
    let selectedColor: Color = .primary
    
    var body: some View {
        Text(place.rawValue)
            .foregroundStyle(place == vm.selectedPlace ? selectedColor : notSelectedColor)
            .font(.title2)
            .bold()
            .onTapGesture {
                withAnimation(.bouncy) {
                    vm.selectedPlace = place
                    vm.selectedSubPlace = vm.selectedPlace.initSubplace()
                }
            }
    }
}

fileprivate struct ShowMenu: View {
    @ObservedObject var vm: MainViewModel
    let time: Time
    let meals: [Meal]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: time.timeToImageString())
                Text(time.rawValue).font(.title2).bold()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.primary.opacity(0.5))
                .padding(.vertical, -5)
            if meals.isEmpty || meals.first!.menu.count < 7 {
                Text("운영하지 않습니다").font(.title3)
            } else {
                ForEach(meals) { meal in
                    Text(meal.menu.replacingOccurrences(of: " ", with: "\n"))
                        .font(.title3)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    MainView()
}
