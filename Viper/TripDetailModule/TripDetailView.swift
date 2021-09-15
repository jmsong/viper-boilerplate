import SwiftUI

struct TripDetailView: View {
  @ObservedObject var presenter: TripDetailPresenter

  var body: some View {
    VStack {
      TextField("Trip Name", text: presenter.setTripName)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding([.horizontal])
      presenter.makeMapView()
      Text(presenter.distanceLabel)
      HStack {
        Spacer()
        EditButton()
        Button(action: presenter.addWaypoint) {
          Text("Add")
        }
      }.padding([.horizontal])
      List {
        ForEach(presenter.waypoints, content: presenter.cell)
          .onMove(perform: presenter.didMoveWaypoint(fromOffsets:toOffset:))
          .onDelete(perform: presenter.didDeleteWaypoint(_:))
      }
    }
    .navigationBarTitle(Text(presenter.tripName), displayMode: .inline)
    .navigationBarItems(trailing: Button("Save", action: presenter.save))
  }
}

struct TripDetailView_Previews: PreviewProvider {
  static var previews: some View {
    let model = DataModel.sample
    let trip = model.trips[1]
    let mapProvider = RealMapDataProvider()
    let presenter = TripDetailPresenter(interactor:
      TripDetailInteractor(
        trip: trip,
        model: model,
        mapInfoProvider: mapProvider))
    return NavigationView {
      TripDetailView(presenter: presenter)
    }
  }
}
