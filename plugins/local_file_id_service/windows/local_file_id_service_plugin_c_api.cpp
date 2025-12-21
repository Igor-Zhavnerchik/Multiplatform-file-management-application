#include "include/local_file_id_service/local_file_id_service_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "local_file_id_service_plugin.h"

void LocalFileIdServicePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  local_file_id_service::LocalFileIdServicePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
