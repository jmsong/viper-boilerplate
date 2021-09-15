import SwiftUI

struct TripMapView: View {
  @ObservedObject var presenter: TripMapViewPresenter

  var body: some View {
    MapView(pins: presenter.pins, routes: presenter.routes)
  }
}

#if DEBUG
struct TripMapView_Previews: PreviewProvider {
  static var previews: some View {
    let model = DataModel.sample
    let trip = model.trips[0]
    let interactor = TripDetailInteractor(
      trip: trip,
      model: model,
      mapInfoProvider: RealMapDataProvider())
    let presenter = TripMapViewPresenter(interactor: interactor)
    return VStack {
      TripMapView(presenter: presenter)
    }
  }
}
#endif
