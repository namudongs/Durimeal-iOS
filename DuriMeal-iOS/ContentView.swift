//
//  ContentView.swift
//  DuriMeal-iOS
//
//  Created by namdghyun on 8/18/24.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            fetchMeals()
            fetchDomsMeals()
        }
    }
    
    
    /// 새롬관, 이룸관 식단을 크롤링하는 함수
    private func fetchDomsMeals() {
        let url = URL(string: "https://knudorm.kangwon.ac.kr/content/K11")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error occured: \(error!.localizedDescription)")
                return
            }
            
            let html = String(data: data, encoding: .utf8)!
            
            do {
                let document = try SwiftSoup.parse(html)
                for placeIndex in 1...2 {
                    let tbody = try document.select(placeIndex.placeIndexToSelector())
                        .select("div:nth-child(7)")
                        .select("tbody")
                    for index in 2...8 {
                        let all = try tbody.select("tr:nth-child(\(index))")
                        let day = try all.select("th").text()
                        for time in 2...4 {
                            let menus = try all.select("td:nth-child(\(time))").text()
                            
                            print(Meal(place: placeIndex.placeIndexToString(),
                                       restaurant: "",
                                       time: time.timeIndexToString(),
                                       day: day,
                                       menus: menus.isEmpty ? "미운영" : menus))
                        }
                    }
                }
                
            } catch Exception.Error(let type, let message) {
                print("Type: \(type), Message: \(message)")
            } catch {
                print("failed to parse html: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    /// 천지관, 백록관, 크누테리아 식단을 크롤링하는 함수
    private func fetchMeals() {
        let params = [10, 20, 30]
        
        for param in params {
            let url = URL(string: "https://wwwk.kangwon.ac.kr/www/selecttnCafMenuListWU.do?key=1077&sc1=CC\(param)&sc2=CC")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("error occured: \(error!.localizedDescription)")
                    return
                }
                
                let html = String(data: data, encoding: .utf8)!
                
                do {
                    let document = try SwiftSoup.parse(html)
                    let rows = try document.select("tbody > tr")
                    
                    for row in rows {
                        let headers = try row.select("th")
                        let data = try row.select("td")
                        
                        guard let category = try headers.first()?.text() else {
                            print("No restaurants found.")
                            return
                        }
                        
                        let timeText = try headers.text()
                        
                        let time: String
                        switch true {
                        case timeText.contains("점심"):
                            time = "점심"
                        case timeText.contains("저녁"):
                            time = "저녁"
                        default:
                            time = "아침"
                        }
                        
                        for (index, item) in data.enumerated() {
                            let menus = try item.text()
                            
                            if category != "구분" && category != "기간" && category != "운영시간" {
                                print(Meal(place: param.paramToPlace(),
                                           restaurant: category,
                                           time: time,
                                           day: index.dayIndexToString(),
                                           menus: menus))
                            }
                        }
                    }
                } catch Exception.Error(let type, let message) {
                    print("Type: \(type), Message: \(message)")
                } catch {
                    print("failed to parse html: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
}

#Preview {
    ContentView()
}
