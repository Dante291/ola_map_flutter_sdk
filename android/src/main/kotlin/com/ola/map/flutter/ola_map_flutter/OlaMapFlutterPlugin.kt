package com.ola.map.flutter.ola_map_flutter

import android.app.Activity
import android.content.Context
import android.graphics.BitmapFactory
import android.util.Log
import android.view.View
import com.ola.mapsdk.camera.MapControlSettings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.ola.mapsdk.interfaces.OlaMapCallback
import com.ola.mapsdk.model.OlaLatLng
import com.ola.mapsdk.model.OlaMarkerOptions
import com.ola.mapsdk.view.OlaMapView
import com.ola.mapsdk.view.OlaMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.ByteArrayInputStream

/** OlaMapFlutterPlugin */
class OlaMapFlutterPlugin : FlutterPlugin, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var mapView: OlaMapView? = null
  private var olaMap: OlaMap? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ola_map_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    mapView = OlaMapView(context)
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      "OlaMapView", OlaMapViewFactory(flutterPluginBinding.binaryMessenger))
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "initializeMap" -> {
        val apiKey = call.argument<String>("apiKey")
        if (apiKey != null) {
          initializeMap(apiKey, result)
        } else {
          Log.e("OlaMapFlutterPlugin", "API key is null")
          result.error("MAP_ERROR", "Please enter your API key", null)
        }
      }
      "addMarker" -> {
        val latitude = call.argument<Double>("latitude") ?: 0.0
        val longitude = call.argument<Double>("longitude") ?: 0.0
        if (olaMap != null) {
          val markerOptions = OlaMarkerOptions.Builder()
            .setMarkerId("marker1")
            .setPosition(OlaLatLng(latitude, longitude))
            .build()
          olaMap?.addMarker(markerOptions)
          result.success("Marker added")
        } else {
          Log.e("OlaMapFlutterPlugin", "Map is not initialized")
          result.error("MAP_ERROR", "Map is not initialized", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  private fun initializeMap(apiKey: String, result: Result) {
    if (mapView == null) {
      mapView = OlaMapView(context)
      Log.d("OlaMapFlutterPlugin", "OlaMapView created")
    }

    mapView?.getMap(apiKey, object : OlaMapCallback {
      override fun onMapReady(map: OlaMap) {
        olaMap= map
        result.success("Map initialized")
        Log.d("OlaMapFlutterPlugin", "Map initialized successfully")
      }

      override fun onMapError(error: String) {
        result.error("MAP_ERROR", error, null)
        Log.e("OlaMapFlutterPlugin", "Map initialization error: $error")
      }
    }) ?: run {
      result.error("MAP_VIEW_NULL", "mapView is null", null)
      Log.e("OlaMapFlutterPlugin", "mapView is null")
    }
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

class OlaMapViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
    val creationParams = args as? Map<String, Any>
    return OlaMapViewController(context, messenger, viewId, creationParams)
  }
}

class OlaMapViewController(
  private val context: Context,
  messenger: BinaryMessenger,
  viewId: Int,
  creationParams: Map<String, Any>?
) : PlatformView {

  private val mapView: OlaMapView = OlaMapView(context)
  private val methodChannel: MethodChannel = MethodChannel(messenger, "ola_map_flutter_$viewId")
  private var olaMap: OlaMap? = null
  init {
    Log.d("OlaMapViewController", "OlaMapView initialized with viewId: $viewId")

    val apiKey = creationParams?.get("apiKey") as? String
    if (apiKey.isNullOrEmpty()) {
      // Return error if apiKey is missing or invalid
      methodChannel.invokeMethod("onError", "API key is missing or invalid")

    }else {
      initializeMap(apiKey);
    }

    methodChannel.setMethodCallHandler { call, result ->
      when (call.method) {
          "getCurrentLocation" -> {
            getCurrentLocation(result)
          }
          "showCurrentLocation" -> {
            showCurrentLocation(result)
          }
          "hideCurrentLocation" -> {
            hideCurrentLocation(result)
          }
          "zoomIn" -> {
            zoomIn(result)
          }
          "zoomOut" -> {
            zoomOut(result)
          }
          "zoomTo" -> {
            zoom(call,result)
          }
          "moveToCurrentLocation" -> {
            moveToSpecifiedLocation(call,result)
          }
          "addMarker" -> {
            addMarker(call,result)
          }
        "removeMarker" -> {
          removeMarker(call, result)
        }
          else -> {
            Log.e("OlaMapViewController", "Unknown method called: ${call.method}")
            result.notImplemented()
          }
      }
    }


  }
  private fun initializeMap(apiKey: String) {
    try {

        Log.d("OlaMapViewController", "API Key is valid, initializing map...")
        val mapControlSettings = MapControlSettings.Builder()
          .setRotateGesturesEnabled(true)
          .setScrollGesturesEnabled(true)
          .setZoomGesturesEnabled(true)
          .setCompassEnabled(true)
          .setTiltGesturesEnabled(true)
          .setDoubleTapGesturesEnabled(true)
          .build()
        mapView.getMap(apiKey, object : OlaMapCallback {
          override fun onMapReady(map: OlaMap) {
            olaMap = map
            methodChannel.invokeMethod("onMapReady", null)
            Log.d("OlaMapFlutterPlugin", "Map initialized successfully")
          }

          override fun onMapError(error: String) {
            methodChannel.invokeMethod("onError", error)
//                result.error("MAP_ERROR", error, null)
            Log.e("OlaMapFlutterPlugin", "Map initialization error: $error")
          }
        },
          mapControlSettings
          )

    } catch (e: Exception) {
      Log.e("OlaMapViewController", "Exception during map initialization: ${e.message}", e)
      methodChannel.invokeMethod("onError",  e.message)
    } finally {
      Log.d("OlaMapViewController", "Finally block executed after map initialization")
    }
  }

  private fun getCurrentLocation(result: MethodChannel.Result) {
    // Ensure we're running on the main thread
//    if (context is Activity) {
    olaMap?.showCurrentLocation()
    val activityContext = context as? Activity
    activityContext?.runOnUiThread {
        if (olaMap == null) {
          result.error("LOCATION_ERROR", "OlaMap instance is not initialized", null)
          return@runOnUiThread
        }

        val currentLocation: OlaLatLng? = olaMap?.getCurrentLocation()
        if (currentLocation != null) {
          Log.d("OlaMapViewController", "Current location: $currentLocation")
          val locationMap = mapOf(
            "latitude" to currentLocation.latitude,
            "longitude" to currentLocation.longitude
          )
          result.success(locationMap)
        } else {
          result.error("LOCATION_ERROR", "Current location is not available", null)
        }
      }

  }

  private fun showCurrentLocation(result: MethodChannel.Result) {
    val activityContext = context as? Activity
    activityContext?.runOnUiThread {
      if (olaMap == null) {
        result.error("LOCATION_ERROR", "OlaMap instance is not initialized", null)
        return@runOnUiThread
      }
      olaMap?.showCurrentLocation()
      result.success("Current location shown")
    }
  }

  private fun hideCurrentLocation(result: MethodChannel.Result) {

    val activityContext = context as? Activity
    activityContext?.runOnUiThread {
      if (olaMap == null) {
        result.error("LOCATION_ERROR", "OlaMap instance is not initialized", null)
        return@runOnUiThread
      }
      olaMap?.hideCurrentLocation()
      result.success("Current location hidden")
    }
  }

  // Function to zoom in the map
  private fun zoomIn(result: Result) {
    val currentCameraPosition = olaMap?.getCurrentOlaCameraPosition()

    // Check if the current camera position is not null
    if (currentCameraPosition != null) {
      val targetLocation = currentCameraPosition.target
      val currentZoomLevel = currentCameraPosition.zoomLevel

      // Check if targetLocation and currentZoomLevel are not null
      if (targetLocation != null) {
        // Zoom in by increasing the zoom level
        olaMap?.zoomToLocation(targetLocation, currentZoomLevel + 1.0)
      } else {
        result.error("LOCATION_ERROR", "Failed to get target location or zoom level", null)

      }
    } else {
      result.error("LOCATION_ERROR", "Failed to get current camera position", null)
    }
  }

  // Function to zoom in the map
  private fun zoom(call: MethodCall, result: Result) {
    val value = call.argument<Double>("value")
    val currentCameraPosition = olaMap?.getCurrentOlaCameraPosition()

    // Check if the current camera position is not null
    if (currentCameraPosition != null) {
      val targetLocation = currentCameraPosition.target
      val currentZoomLevel = currentCameraPosition.zoomLevel

      // Check if targetLocation and currentZoomLevel are not null
      if (targetLocation != null && value != null) {
        // Zoom in by increasing the zoom level
        olaMap?.zoomToLocation(targetLocation, value)
        result.success(null)
      } else {
        result.error("LOCATION_ERROR", "Failed to get target location or zoom level", null)

      }
    } else {
      result.error("LOCATION_ERROR", "Failed to get current camera position", null)
    }
  }

  // Function to zoom out the map
  private fun zoomOut(result: Result) {
    val currentCameraPosition = olaMap?.getCurrentOlaCameraPosition()

    // Check if the current camera position is not null
    if (currentCameraPosition != null) {
      val targetLocation = currentCameraPosition.target
      val currentZoomLevel = currentCameraPosition.zoomLevel

      // Check if targetLocation and currentZoomLevel are not null
      if (targetLocation != null) {
        // Zoom out by decreasing the zoom level
        olaMap?.zoomToLocation(targetLocation, currentZoomLevel - 1.0)
      } else {
        result.error("LOCATION_ERROR", "Failed to get target location or zoom level", null)
      }
    } else {
      result.error("LOCATION_ERROR", "Failed to get current camera position", null)
    }
  }

  private fun moveToSpecifiedLocation(call: MethodCall, result: Result) {
    val latitude = call.argument<Double>("latitude")
    val longitude = call.argument<Double>("longitude")

    if (latitude != null && longitude != null) {
      val location = OlaLatLng(latitude, longitude)
      val zoomLevel = 15.0 // Set the desired zoom level
      olaMap?.moveCameraToLatLong(location, zoomLevel)
      result.success(null)
    } else {
      result.error("LOCATION_ERROR", "Latitude or Longitude is missing or invalid", null)
    }
  }

  private fun addMarker(call: MethodCall, result: Result) {
    val markerId = call.argument<String>("markerId")
    val latitude = call.argument<Double>("latitude")
    val longitude = call.argument<Double>("longitude")
    val imageBytes = call.argument<ByteArray>("imageBytes") // Get the image bytes
    val setIsIconClickable = call.argument<Boolean>("setIsIconClickable")
    val  setIsAnimationEnable = call.argument<Boolean>("setIsAnimationEnable")
    val setIsInfoWindowDismissOnClick  = call.argument<Boolean>("setIsInfoWindowDismissOnClick")

    if (markerId != null && latitude != null && longitude != null && imageBytes != null) {
      val markerOptionsBuilder = OlaMarkerOptions.Builder()
        .setMarkerId(markerId)
        .setPosition(OlaLatLng(latitude, longitude))
        .setIsIconClickable(true)
        .setIconRotation(0f)
        .setIsAnimationEnable(true)
        .setIsInfoWindowDismissOnClick(true)

      // Decode the image bytes and set as marker icon
      val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(imageBytes))
      markerOptionsBuilder.setIconBitmap(bitmap)

      olaMap?.addMarker(markerOptionsBuilder.build())
      result.success(null)
    } else {
      result.error("INVALID_ARGUMENTS", "Marker ID, latitude, longitude, or imageBytes missing", null)
    }
  }

  private fun removeMarker(call: MethodCall, result: Result) {
    val markerId = call.argument<String>("markerId")

    val markerOptionsBuilder = OlaMarkerOptions.Builder()
      .setMarkerId(markerId ?: "").build()
    val marker1 = olaMap?.addMarker(markerOptionsBuilder)
    marker1?.removeMarker();

  }

  override fun getView(): View {
    Log.d("OlaMapViewController", "Returning mapView")
    return mapView
  }

  override fun dispose() {
    Log.d("OlaMapViewController", "Disposing OlaMapView")
    // Cleanup resources if necessary
  }
}
