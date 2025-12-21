#ifndef FLUTTER_PLUGIN_LOCAL_FILE_ID_SERVICE_PLUGIN_H_
#define FLUTTER_PLUGIN_LOCAL_FILE_ID_SERVICE_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _LocalFileIdServicePlugin LocalFileIdServicePlugin;
typedef struct {
  GObjectClass parent_class;
} LocalFileIdServicePluginClass;

FLUTTER_PLUGIN_EXPORT GType local_file_id_service_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void local_file_id_service_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_LOCAL_FILE_ID_SERVICE_PLUGIN_H_
