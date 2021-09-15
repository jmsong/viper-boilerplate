import SwiftUI
import Combine

class TripListPresenter: ObservableObject {
  private let interactor: TripListInteractor
  private let router = TripListRouter()
  
  private var cancellables = Set<AnyCancellable>()
  
  @Published var trips: [Trip] = []
  
  init(interactor: TripListInteractor) {
    self.interactor = interactor
    
    interactor.model.$trips
      .assign(to: \.trips, on: self)
      .store(in: &cancellables)
  }
  
  func makeAddNewButton() -> some View {
    Button(action: addNewTrip) {
      Image(systemName: "plus")
    }
  }
  
  func addNewTrip() {
    interactor.addNewTrip()
  }
  
  func deleteTrip(_ index: IndexSet) {
    interactor.deleteTrip(index)
  }
  
  func linkBuilder<Content: View>(for trip: Trip, @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(destination: router.makeDetailView(for: trip, model: interactor.model)) {
      content()
    }
  }  
}
