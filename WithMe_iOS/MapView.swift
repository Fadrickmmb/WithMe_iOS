import SwiftUI
import GoogleMaps
import CoreLocation
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.delegate = context.coordinator

        if let coordinate = selectedCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            view.removeAnnotations(view.annotations)
            view.addAnnotation(annotation)

            if view.centerCoordinate.latitude != coordinate.latitude || view.centerCoordinate.longitude != coordinate.longitude {
                view.setCenter(coordinate, animated: true)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            parent.selectedCoordinate = coordinate
        }
    }
}

struct EquatableLocation: Equatable {
    var coordinate: CLLocationCoordinate2D

    static func == (lhs: EquatableLocation, rhs: EquatableLocation) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
