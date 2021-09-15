import SwiftUI
import Combine

class TripDetailPresenter: ObservableObject {
  private let interactor: TripDetailInteractor
  private let router: TripDetailRouter

  private var cancellables = Set<AnyCancellable>()

  @Published var tripName: String = "No name"
  let setTripName: Binding<String>
  @Published var distanceLabel: String = "Calculating..."
  @Published var waypoints: [Waypoint] = []

  init(interactor: TripDetailInteractor) {
    self.interactor = interactor
    self.router = TripDetailRouter(mapProvider: interactor.mapInfoProvider)

    // 1
    setTripName = Binding<String>(
      get: { interactor.tripName },
      set: { interactor.setTripName($0) }
    )

    // 2
    interactor.tripNamePublisher
      .assign(to: \.tripName, on: self)
      .store(in: &cancellables)

    interactor.$totalDistance
      .map { "Total Distance: " + MeasurementFormatter().string(from: $0) }
      .replaceNil(with: "Calculating...")
      .assign(to: \.distanceLabel, on: self)
      .store(in: &cancellables)

    interactor.$waypoints
      .assign(to: \.waypoints, on: self)
      .store(in: &cancellables)
  }

  func save() {
    interactor.save()
  }

  func makeMapView() -> some View {
    TripMapView(presenter: TripMapViewPresenter(interactor: interactor))
  }

  // MARK: - Waypoints

  func addWaypoint() {
    interactor.addWaypoint()
  }

  func didMoveWaypoint(fromOffsets: IndexSet, toOffset: Int) {
    interactor.moveWaypoint(fromOffsets: fromOffsets, toOffset: toOffset)
  }

  func didDeleteWaypoint(_ atOffsets: IndexSet) {
    interactor.deleteWaypoint(atOffsets: atOffsets)
  }

  func cell(for waypoint: Waypoint) -> some View {
    let destination = router.makeWaypointView(for: waypoint)
      .onDisappear(perform: interactor.updateWaypoints)
    return NavigationLink(destination: destination) {
      Text(waypoint.name)
    }
  }
}
