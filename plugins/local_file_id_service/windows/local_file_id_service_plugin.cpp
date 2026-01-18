#include "local_file_id_service_plugin.h"

// Must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>
#include <string>

namespace {

std::wstring Utf8ToWide(const std::string& utf8) {
  if (utf8.empty()) {
    return std::wstring();
  }

  int sizeNeeded = MultiByteToWideChar(
      CP_UTF8,
      0,
      utf8.data(),
      static_cast<int>(utf8.size()),
      nullptr,
      0);

  if (sizeNeeded <= 0) {
    return std::wstring();
  }

  std::wstring wide(sizeNeeded, 0);
  MultiByteToWideChar(
      CP_UTF8,
      0,
      utf8.data(),
      static_cast<int>(utf8.size()),
      &wide[0],
      sizeNeeded);

  return wide;
}

std::string GetFileId(const std::wstring& path) {
  HANDLE hFile = CreateFileW(
      path.c_str(),
      0,
      FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
      nullptr,
      OPEN_EXISTING,
      FILE_FLAG_BACKUP_SEMANTICS, // required for directories
      nullptr);

  if (hFile == INVALID_HANDLE_VALUE) {
    return "";
  }

  BY_HANDLE_FILE_INFORMATION info;
  if (!GetFileInformationByHandle(hFile, &info)) {
    CloseHandle(hFile);
    return "";
  }

  CloseHandle(hFile);

  std::ostringstream oss;
  oss << info.dwVolumeSerialNumber << "-"
      << info.nFileIndexHigh << "-"
      << info.nFileIndexLow;

  return oss.str();
}

}  // namespace

namespace local_file_id_service {

// static
void LocalFileIdServicePlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(),
          "local_file_id_service",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<LocalFileIdServicePlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

LocalFileIdServicePlugin::LocalFileIdServicePlugin() = default;
LocalFileIdServicePlugin::~LocalFileIdServicePlugin() = default;

void LocalFileIdServicePlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  if (method_call.method_name() != "getFileId") {
    result->NotImplemented();
    return;
  }

  const auto* args =
      std::get_if<flutter::EncodableMap>(method_call.arguments());

  if (!args) {
    result->Error("invalid_args", "Arguments expected");
    return;
  }

  auto it = args->find(flutter::EncodableValue("path"));
  if (it == args->end()) {
    result->Error("invalid_args", "Missing 'path'");
    return;
  }

  const auto* pathUtf8 = std::get_if<std::string>(&it->second);
  if (!pathUtf8) {
    result->Error("invalid_args", "'path' must be a string");
    return;
  }

  std::wstring widePath = Utf8ToWide(*pathUtf8);
  if (widePath.empty()) {
    result->Error("invalid_args", "Failed to convert path to UTF-16");
    return;
  }

  auto fileId = GetFileId(widePath);
  if (fileId.empty()) {
    result->Error("io_error", "Failed to get file id");
    return;
  }

  result->Success(flutter::EncodableValue(fileId));
}

}  // namespace local_file_id_service
