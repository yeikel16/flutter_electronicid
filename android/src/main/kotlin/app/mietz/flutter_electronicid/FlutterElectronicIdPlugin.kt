package app.mietz.flutter_electronicid

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import eu.electronicid.sdk.base.model.Environment
import eu.electronicid.sdk.base.ui.base.VideoIdServiceActivity
import eu.electronicid.sdk.discriminator.CheckRequirements
import eu.electronicid.sdk.ExtraModulesProvider.Companion.loadEidKoinModules
import eu.electronicid.sdk.ui.videoid.VideoIDActivity
import eu.electronicid.sdk.ui.videoscan.VideoScanActivity

import io.flutter.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.net.URL

const val Tag = "FlutterElectronicIdPlugin"

/** FlutterElectronicIdPlugin */
class FlutterElectronicIdPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private lateinit var binaryMessenger: BinaryMessenger
  private var activity: FlutterFragmentActivity? = null
  private var result: Result? = null
  private var startVideoID: ActivityResultLauncher<Intent>? = null

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    try {
      channel = MethodChannel(binaryMessenger, "flutter_electronicid")
      channel.setMethodCallHandler(this)
      loadEidKoinModules(context)
      activity = binding.activity as FlutterFragmentActivity

      registerStartVideoId()
    } catch (ex: Exception) {
      Log.w(Tag, ex.message.toString())
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivity() {}

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    binaryMessenger = flutterPluginBinding.binaryMessenger
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun registerStartVideoId() {
    startVideoID = activity?.registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { intentResult ->
      val data = intentResult.data
      if (intentResult.resultCode == Activity.RESULT_OK) {
        data?.run {
          val videoId = getStringExtra(VideoIdServiceActivity.RESULT_OK)
          result?.success(videoId)
        }
      } else if (intentResult.resultCode == Activity.RESULT_CANCELED) {
        data?.run {
          val errorId = getStringExtra(VideoIdServiceActivity.RESULT_ERROR_CODE)
          val errorMsg = getStringExtra(VideoIdServiceActivity.RESULT_ERROR_MESSAGE)
          result?.error(errorId ?: "VideoIDError", errorMsg, null)
        }
      }
    }
  }

  private fun checkRequirements(endpoint: String) {
    if (activity != null) {
      CheckRequirements.getInstance(activity!!).checkVideoID(URL(endpoint), {
        Log.d(Tag, "Checking Video ID requirements: $it/10")
      }) { response ->
        if (response.passed) {
          result?.success(true)
        } else {
          result?.success(false)
        }
      }
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    this.result = result
    when (call.method) {
        "openVideoID" -> {
          val config = call.argument<Map<*, *>>("configuration")
          if (config == null) {
            result.error("VideoIDError", "Missing VideoID configuration", null)
            return
          }
          val authorization = config["authorization"] as String
          val endpoint = config["endpoint"] as String
          val language = config["language"] as String
          val document = config["document"] as Int?
          val defaultDocument = config["defaultDocument"] as Int?

          startVideoID?.launch(Intent(activity, VideoIDActivity::class.java).apply {
            putExtra(
              VideoIDActivity.ENVIRONMENT,
              Environment(
                URL(endpoint),
                authorization
              )
            )
            putExtra(VideoIDActivity.LANGUAGE, language)
            if (document != null) putExtra(VideoIDActivity.ID_DOCUMENT, document)
            if (defaultDocument != null) putExtra(VideoIDActivity.ID_DEFAULT, defaultDocument)
          })
        }
        "openVideoIdMedium" -> {
          val config = call.argument<Map<*, *>>("configuration")
          if (config == null) {
            result.error("VideoIDMediumError", "Missing VideoIDMedium configuration", null)
            return
          }
          val authorization = config["authorization"] as String
          val endpoint = config["endpoint"] as String
          val language = config["language"] as String
          val document = config["document"] as Int?
          val defaultDocument = config["defaultDocument"] as Int?

          startVideoID?.launch(Intent(activity, VideoScanActivity::class.java).apply {
            putExtra(
              VideoScanActivity.ENVIRONMENT,
              Environment(
                URL(endpoint),
                authorization
              )
            )
            putExtra(VideoScanActivity.LANGUAGE, language)
            if (document != null) putExtra(VideoScanActivity.ID_DOCUMENT, document)
            if (defaultDocument != null) putExtra(VideoScanActivity.ID_DEFAULT, defaultDocument)
          })
        }
        "checkRequirements" -> {
          val endpoint = call.argument<String>("endpoint")
          if (endpoint != null) {
            checkRequirements(endpoint)
          } else {
            result.error("VideoIDError", "Endpoint is required for checkRequirements", null)
          }
        }
        else -> {
          result.notImplemented()
        }
    }
  }
}
