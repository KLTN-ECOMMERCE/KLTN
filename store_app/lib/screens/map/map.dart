import 'dart:async';

import 'package:flutter/material.dart';
import 'package:store_app/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:store_app/utils/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const Place(
      latitude: 10.777215521004981,
      longitude: 106.69572052044951,
      address: '',
    ),
    this.isSelecting = true,
  });

  final Place location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  final _searchController = TextEditingController();
  final searchOutlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  final _mapController = Completer<GoogleMapController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var initCamera = CameraPosition(
      target: LatLng(
        widget.location.latitude,
        widget.location.longitude,
      ),
      zoom: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(
                  _pickedLocation,
                );
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _searchController,
              googleAPIKey: 'AIzaSyDefmc5IMJgfB6bkf3D-RxrTyidNFdkrUs',
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: kSecondaryColor.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: searchOutlineInputBorder,
                focusedBorder: searchOutlineInputBorder,
                enabledBorder: searchOutlineInputBorder,
                hintText: "Search your address",
                prefixIcon: const Icon(Icons.search),
              ),
              itemClick: (postalCodeResponse) {
                _searchController.text =
                    postalCodeResponse.description.toString();
                _searchController.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: postalCodeResponse.description!.length,
                  ),
                );
              },
              getPlaceDetailWithLatLng: (postalCodeResponse) async {
                setState(() {
                  _pickedLocation = LatLng(
                    double.parse(postalCodeResponse.lat!),
                    double.parse(postalCodeResponse.lng!),
                  );
                });
                final controller = await _mapController.future;
                controller.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                      double.parse(postalCodeResponse.lat!),
                      double.parse(postalCodeResponse.lng!),
                    ),
                  ),
                );
              },
              itemBuilder: (context, index, prediction) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Text(prediction.description ?? ""),
                      ),
                    ],
                  ),
                );
              },
              seperatedBuilder: const Divider(),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onTap: widget.isSelecting
                  ? (argument) async {
                      setState(() {
                        _pickedLocation = argument;
                      });
                      final controller = await _mapController.future;
                      controller.animateCamera(
                        CameraUpdate.newLatLng(argument),
                      );
                    }
                  : null,
              initialCameraPosition: initCamera,
              markers: (_pickedLocation == null && widget.isSelecting)
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('m1'),
                        position: _pickedLocation != null
                            ? _pickedLocation!
                            : LatLng(
                                widget.location.latitude,
                                widget.location.longitude,
                              ),
                      ),
                    },
              // cameraTargetBounds: _pickedLocation != null
              //     ? CameraTargetBounds(
              //         LatLngBounds(
              //           northeast: _pickedLocation!,
              //           southwest: _pickedLocation!,
              //         ),
              //       )
              //     : CameraTargetBounds.unbounded,
              onMapCreated: (controller) {
                _mapController.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
