package com.example.local_file_id_service

import android.system.Os
import android.system.StructStat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class LocalFileIdServicePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "local_file_id_service")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "getFileId" -> {
                val path = call.argument<String>("path")
                if (path != null) {
                    getFileId(path, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Path is null", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getFileId(path: String, result: Result) {
        try {
            val file = File(path)
            if (file.exists()) {
                // Вызов системной функции stat для получения inode
                val stat: StructStat = Os.stat(path)
                // Возвращаем как String, чтобы соответствовать вашему Dart-коду
                result.success(stat.st_ino.toString())
            } else {
                result.error("NOT_FOUND", "File not found at path: $path", null)
            }
        } catch (e: Exception) {
            result.error("SYS_ERR", "Failed to get inode: ${e.localizedMessage}", null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}