//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <local_file_id_service/local_file_id_service_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) local_file_id_service_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "LocalFileIdServicePlugin");
  local_file_id_service_plugin_register_with_registrar(local_file_id_service_registrar);
}
