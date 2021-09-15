import SwiftUI

class TripDetailRouter {
  private let mapProvider: MapDataProvider

  init(mapProvider: MapDataProvider) {
    self.mapProvider = mapProvider
  }

  func makeWaypointView(for waypoint: Waypoint) -> some View {
    let presenter = WaypointViewPresenter(
      waypoint: waypoint,
      interactor: WaypointViewInteractor(
        waypoint: waypoint,
        mapInfoProvider: mapProvider))
    return WaypointView(presenter: presenter)
  }
}
