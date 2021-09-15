import SwiftUI

struct ContentView: View {
  @EnvironmentObject var model: DataModel

  var body: some View {
    NavigationView {
      TripListView(presenter:
      TripListPresenter(interactor:
        TripListInteractor(model: model)))
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let model = DataModel.sample
    return ContentView()
      .environmentObject(model)
  }
}
#endif
