package io.param.remind.remind_me

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private var methodChannel: MethodChannel? = null
    private lateinit var sensorManager: SensorManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //setup channel
        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        tearDownChannels()
        super.onDestroy()
    }

    private fun tearDownChannels() {
        methodChannel?.setMethodCallHandler(null)
    }

    private fun setupChannels(context: Context, messenger: BinaryMessenger) {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "testMethod") {
                print("TEST-PARAM: isSensorAvailable success")
                val message = call.argument<String>("key")
                Log.d("TAG-PARAM", "Message: $message")
                Toast.makeText(this, "Message:$message", Toast.LENGTH_SHORT).show()
                //result.success(sensorManager.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
                result.success(true)
            } else {
                Log.d("TAG-PARAM", "test method not called")
                result.notImplemented()
            }
        }
    }

    companion object {
        private val METHOD_CHANNEL_NAME = "com.param.remindme/method"
    }
}
