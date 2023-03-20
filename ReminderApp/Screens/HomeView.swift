//
//  ContentView.swift
//  ReminderApp
//
//  Created by mert can çifter on 10.03.2023.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject private var myListViewModel: MyListViewModel
    
    init(vm: MyListViewModel) {
        self.myListViewModel = vm
    }
            
    @State private var isPresented: Bool = false
    @State private var search: String = ""
    @State private var searching: Bool = false
    
    
    @State var active: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                               
                    HStack {
                        
                        NavigationLink {
                            ReminderFilterView(vm: ReminderFilterViewModel(context: viewContext, type: .today))
                        } label: {
                            ReminderStatsView(icon: "calendar", title: "Bugün", count: myListViewModel.reminderStatsValues.todayCount)
                        }
                        
                        NavigationLink {
                            ReminderFilterView(vm: ReminderFilterViewModel(context: viewContext, type: .scheduled))
                        } label: {
                            ReminderStatsView(icon: "calendar.circle.fill", title: "Planlanmış", count: myListViewModel.reminderStatsValues.scheduledCount, iconColor: .red)
                        }
                    }
                    
                    HStack {
                       
                        NavigationLink {
                            ReminderFilterView(vm: ReminderFilterViewModel(context: viewContext, type: .all))
                        } label: {
                            ReminderStatsView(icon: "tray.circle.fill", title: "Hepsi", count: myListViewModel.reminderStatsValues.allCount, iconColor: .secondary)
                        }
                        
                        NavigationLink {
                            ReminderFilterView(vm: ReminderFilterViewModel(context: viewContext, type: .completed))
                        } label: {
                            ReminderStatsView(icon: "checkmark.circle.fill", title: "Tamamlanmış", count: myListViewModel.reminderStatsValues.completedCount, iconColor: .primary)
                        }
                    }
                    
                    Text("Listem")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .padding()
                    
                    MyListView(myLists: myListViewModel.myList)
                                        
                    
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    AddNewListView { name, color in
                        myListViewModel.addList(name: name, color: color)
                    }
                }
            }
            .listStyle(.plain)
            .onChange(of: search, perform: { searchTerm in
                searching = !searchTerm.isEmpty ? true : false
                myListViewModel.getRemindersByTitle(title: search)
            })
            .overlay(alignment: .center, content: {
                ReminderListView(reminders: myListViewModel.reminders)
                    .opacity(searching ? 1.0 : 0.0)
            })
            .onAppear {
                myListViewModel.dailyReportFetch()
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Text("Yeni Liste")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }.padding()
                }
            }
            .padding()
            .navigationTitle("Hatırlatıcılar")

        }.searchable(text: $search,prompt: "Arama yap...")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
        
        HomeView(vm: MyListViewModel(context: viewContext))
            .environment(\.managedObjectContext, viewContext)
    }
}
