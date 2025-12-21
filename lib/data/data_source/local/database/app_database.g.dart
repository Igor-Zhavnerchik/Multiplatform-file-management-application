// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FilesTable extends Files with TableInfo<$FilesTable, DbFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempParentIdMeta = const VerificationMeta(
    'tempParentId',
  );
  @override
  late final GeneratedColumn<String> tempParentId = GeneratedColumn<String>(
    'temp_parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depthMeta = const VerificationMeta('depth');
  @override
  late final GeneratedColumn<int> depth = GeneratedColumn<int>(
    'depth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localFileIdMeta = const VerificationMeta(
    'localFileId',
  );
  @override
  late final GeneratedColumn<String> localFileId = GeneratedColumn<String>(
    'local_file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFolderMeta = const VerificationMeta(
    'isFolder',
  );
  @override
  late final GeneratedColumn<bool> isFolder = GeneratedColumn<bool>(
    'is_folder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_folder" IN (0, 1))',
    ),
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncEnabledMeta = const VerificationMeta(
    'syncEnabled',
  );
  @override
  late final GeneratedColumn<bool> syncEnabled = GeneratedColumn<bool>(
    'sync_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _downloadEnabledMeta = const VerificationMeta(
    'downloadEnabled',
  );
  @override
  late final GeneratedColumn<bool> downloadEnabled = GeneratedColumn<bool>(
    'download_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("download_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _downloadStatusMeta = const VerificationMeta(
    'downloadStatus',
  );
  @override
  late final GeneratedColumn<String> downloadStatus = GeneratedColumn<String>(
    'download_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    tempParentId,
    ownerId,
    depth,
    localFileId,
    size,
    hash,
    isFolder,
    mimeType,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
    syncEnabled,
    downloadEnabled,
    downloadStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'files';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('temp_parent_id')) {
      context.handle(
        _tempParentIdMeta,
        tempParentId.isAcceptableOrUnknown(
          data['temp_parent_id']!,
          _tempParentIdMeta,
        ),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('depth')) {
      context.handle(
        _depthMeta,
        depth.isAcceptableOrUnknown(data['depth']!, _depthMeta),
      );
    } else if (isInserting) {
      context.missing(_depthMeta);
    }
    if (data.containsKey('local_file_id')) {
      context.handle(
        _localFileIdMeta,
        localFileId.isAcceptableOrUnknown(
          data['local_file_id']!,
          _localFileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFileIdMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    }
    if (data.containsKey('is_folder')) {
      context.handle(
        _isFolderMeta,
        isFolder.isAcceptableOrUnknown(data['is_folder']!, _isFolderMeta),
      );
    } else if (isInserting) {
      context.missing(_isFolderMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('sync_enabled')) {
      context.handle(
        _syncEnabledMeta,
        syncEnabled.isAcceptableOrUnknown(
          data['sync_enabled']!,
          _syncEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncEnabledMeta);
    }
    if (data.containsKey('download_enabled')) {
      context.handle(
        _downloadEnabledMeta,
        downloadEnabled.isAcceptableOrUnknown(
          data['download_enabled']!,
          _downloadEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadEnabledMeta);
    }
    if (data.containsKey('download_status')) {
      context.handle(
        _downloadStatusMeta,
        downloadStatus.isAcceptableOrUnknown(
          data['download_status']!,
          _downloadStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      tempParentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_parent_id'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      depth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}depth'],
      )!,
      localFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_id'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      ),
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      ),
      isFolder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_folder'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_enabled'],
      )!,
      downloadEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}download_enabled'],
      )!,
      downloadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}download_status'],
      )!,
    );
  }

  @override
  $FilesTable createAlias(String alias) {
    return $FilesTable(attachedDatabase, alias);
  }
}

class DbFile extends DataClass implements Insertable<DbFile> {
  final String id;
  final String name;
  final String? parentId;
  final String? tempParentId;
  final String ownerId;
  final int depth;
  final String localFileId;
  final int? size;
  final String? hash;
  final bool isFolder;
  final String? mimeType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final bool syncEnabled;
  final bool downloadEnabled;
  final String downloadStatus;
  const DbFile({
    required this.id,
    required this.name,
    this.parentId,
    this.tempParentId,
    required this.ownerId,
    required this.depth,
    required this.localFileId,
    this.size,
    this.hash,
    required this.isFolder,
    this.mimeType,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
    required this.syncEnabled,
    required this.downloadEnabled,
    required this.downloadStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || tempParentId != null) {
      map['temp_parent_id'] = Variable<String>(tempParentId);
    }
    map['owner_id'] = Variable<String>(ownerId);
    map['depth'] = Variable<int>(depth);
    map['local_file_id'] = Variable<String>(localFileId);
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String>(hash);
    }
    map['is_folder'] = Variable<bool>(isFolder);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_enabled'] = Variable<bool>(syncEnabled);
    map['download_enabled'] = Variable<bool>(downloadEnabled);
    map['download_status'] = Variable<String>(downloadStatus);
    return map;
  }

  FilesCompanion toCompanion(bool nullToAbsent) {
    return FilesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      tempParentId: tempParentId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempParentId),
      ownerId: Value(ownerId),
      depth: Value(depth),
      localFileId: Value(localFileId),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
      isFolder: Value(isFolder),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      syncEnabled: Value(syncEnabled),
      downloadEnabled: Value(downloadEnabled),
      downloadStatus: Value(downloadStatus),
    );
  }

  factory DbFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbFile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      tempParentId: serializer.fromJson<String?>(json['tempParentId']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      depth: serializer.fromJson<int>(json['depth']),
      localFileId: serializer.fromJson<String>(json['localFileId']),
      size: serializer.fromJson<int?>(json['size']),
      hash: serializer.fromJson<String?>(json['hash']),
      isFolder: serializer.fromJson<bool>(json['isFolder']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncEnabled: serializer.fromJson<bool>(json['syncEnabled']),
      downloadEnabled: serializer.fromJson<bool>(json['downloadEnabled']),
      downloadStatus: serializer.fromJson<String>(json['downloadStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'tempParentId': serializer.toJson<String?>(tempParentId),
      'ownerId': serializer.toJson<String>(ownerId),
      'depth': serializer.toJson<int>(depth),
      'localFileId': serializer.toJson<String>(localFileId),
      'size': serializer.toJson<int?>(size),
      'hash': serializer.toJson<String?>(hash),
      'isFolder': serializer.toJson<bool>(isFolder),
      'mimeType': serializer.toJson<String?>(mimeType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncEnabled': serializer.toJson<bool>(syncEnabled),
      'downloadEnabled': serializer.toJson<bool>(downloadEnabled),
      'downloadStatus': serializer.toJson<String>(downloadStatus),
    };
  }

  DbFile copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    Value<String?> tempParentId = const Value.absent(),
    String? ownerId,
    int? depth,
    String? localFileId,
    Value<int?> size = const Value.absent(),
    Value<String?> hash = const Value.absent(),
    bool? isFolder,
    Value<String?> mimeType = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    bool? syncEnabled,
    bool? downloadEnabled,
    String? downloadStatus,
  }) => DbFile(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    tempParentId: tempParentId.present ? tempParentId.value : this.tempParentId,
    ownerId: ownerId ?? this.ownerId,
    depth: depth ?? this.depth,
    localFileId: localFileId ?? this.localFileId,
    size: size.present ? size.value : this.size,
    hash: hash.present ? hash.value : this.hash,
    isFolder: isFolder ?? this.isFolder,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    syncEnabled: syncEnabled ?? this.syncEnabled,
    downloadEnabled: downloadEnabled ?? this.downloadEnabled,
    downloadStatus: downloadStatus ?? this.downloadStatus,
  );
  DbFile copyWithCompanion(FilesCompanion data) {
    return DbFile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      tempParentId: data.tempParentId.present
          ? data.tempParentId.value
          : this.tempParentId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      depth: data.depth.present ? data.depth.value : this.depth,
      localFileId: data.localFileId.present
          ? data.localFileId.value
          : this.localFileId,
      size: data.size.present ? data.size.value : this.size,
      hash: data.hash.present ? data.hash.value : this.hash,
      isFolder: data.isFolder.present ? data.isFolder.value : this.isFolder,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncEnabled: data.syncEnabled.present
          ? data.syncEnabled.value
          : this.syncEnabled,
      downloadEnabled: data.downloadEnabled.present
          ? data.downloadEnabled.value
          : this.downloadEnabled,
      downloadStatus: data.downloadStatus.present
          ? data.downloadStatus.value
          : this.downloadStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbFile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('tempParentId: $tempParentId, ')
          ..write('ownerId: $ownerId, ')
          ..write('depth: $depth, ')
          ..write('localFileId: $localFileId, ')
          ..write('size: $size, ')
          ..write('hash: $hash, ')
          ..write('isFolder: $isFolder, ')
          ..write('mimeType: $mimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('downloadEnabled: $downloadEnabled, ')
          ..write('downloadStatus: $downloadStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentId,
    tempParentId,
    ownerId,
    depth,
    localFileId,
    size,
    hash,
    isFolder,
    mimeType,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
    syncEnabled,
    downloadEnabled,
    downloadStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbFile &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.tempParentId == this.tempParentId &&
          other.ownerId == this.ownerId &&
          other.depth == this.depth &&
          other.localFileId == this.localFileId &&
          other.size == this.size &&
          other.hash == this.hash &&
          other.isFolder == this.isFolder &&
          other.mimeType == this.mimeType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncEnabled == this.syncEnabled &&
          other.downloadEnabled == this.downloadEnabled &&
          other.downloadStatus == this.downloadStatus);
}

class FilesCompanion extends UpdateCompanion<DbFile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<String?> tempParentId;
  final Value<String> ownerId;
  final Value<int> depth;
  final Value<String> localFileId;
  final Value<int?> size;
  final Value<String?> hash;
  final Value<bool> isFolder;
  final Value<String?> mimeType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<bool> syncEnabled;
  final Value<bool> downloadEnabled;
  final Value<String> downloadStatus;
  final Value<int> rowid;
  const FilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.tempParentId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.depth = const Value.absent(),
    this.localFileId = const Value.absent(),
    this.size = const Value.absent(),
    this.hash = const Value.absent(),
    this.isFolder = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncEnabled = const Value.absent(),
    this.downloadEnabled = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FilesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.tempParentId = const Value.absent(),
    required String ownerId,
    required int depth,
    required String localFileId,
    this.size = const Value.absent(),
    this.hash = const Value.absent(),
    required bool isFolder,
    this.mimeType = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String syncStatus,
    required bool syncEnabled,
    required bool downloadEnabled,
    required String downloadStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       ownerId = Value(ownerId),
       depth = Value(depth),
       localFileId = Value(localFileId),
       isFolder = Value(isFolder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus),
       syncEnabled = Value(syncEnabled),
       downloadEnabled = Value(downloadEnabled),
       downloadStatus = Value(downloadStatus);
  static Insertable<DbFile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? tempParentId,
    Expression<String>? ownerId,
    Expression<int>? depth,
    Expression<String>? localFileId,
    Expression<int>? size,
    Expression<String>? hash,
    Expression<bool>? isFolder,
    Expression<String>? mimeType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<bool>? syncEnabled,
    Expression<bool>? downloadEnabled,
    Expression<String>? downloadStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (tempParentId != null) 'temp_parent_id': tempParentId,
      if (ownerId != null) 'owner_id': ownerId,
      if (depth != null) 'depth': depth,
      if (localFileId != null) 'local_file_id': localFileId,
      if (size != null) 'size': size,
      if (hash != null) 'hash': hash,
      if (isFolder != null) 'is_folder': isFolder,
      if (mimeType != null) 'mime_type': mimeType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncEnabled != null) 'sync_enabled': syncEnabled,
      if (downloadEnabled != null) 'download_enabled': downloadEnabled,
      if (downloadStatus != null) 'download_status': downloadStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<String?>? tempParentId,
    Value<String>? ownerId,
    Value<int>? depth,
    Value<String>? localFileId,
    Value<int?>? size,
    Value<String?>? hash,
    Value<bool>? isFolder,
    Value<String?>? mimeType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<bool>? syncEnabled,
    Value<bool>? downloadEnabled,
    Value<String>? downloadStatus,
    Value<int>? rowid,
  }) {
    return FilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      tempParentId: tempParentId ?? this.tempParentId,
      ownerId: ownerId ?? this.ownerId,
      depth: depth ?? this.depth,
      localFileId: localFileId ?? this.localFileId,
      size: size ?? this.size,
      hash: hash ?? this.hash,
      isFolder: isFolder ?? this.isFolder,
      mimeType: mimeType ?? this.mimeType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      downloadEnabled: downloadEnabled ?? this.downloadEnabled,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (tempParentId.present) {
      map['temp_parent_id'] = Variable<String>(tempParentId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (depth.present) {
      map['depth'] = Variable<int>(depth.value);
    }
    if (localFileId.present) {
      map['local_file_id'] = Variable<String>(localFileId.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (isFolder.present) {
      map['is_folder'] = Variable<bool>(isFolder.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncEnabled.present) {
      map['sync_enabled'] = Variable<bool>(syncEnabled.value);
    }
    if (downloadEnabled.present) {
      map['download_enabled'] = Variable<bool>(downloadEnabled.value);
    }
    if (downloadStatus.present) {
      map['download_status'] = Variable<String>(downloadStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('tempParentId: $tempParentId, ')
          ..write('ownerId: $ownerId, ')
          ..write('depth: $depth, ')
          ..write('localFileId: $localFileId, ')
          ..write('size: $size, ')
          ..write('hash: $hash, ')
          ..write('isFolder: $isFolder, ')
          ..write('mimeType: $mimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('downloadEnabled: $downloadEnabled, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FilesTable files = $FilesTable(this);
  late final FilesDao filesDao = FilesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [files];
}

typedef $$FilesTableCreateCompanionBuilder =
    FilesCompanion Function({
      required String id,
      required String name,
      Value<String?> parentId,
      Value<String?> tempParentId,
      required String ownerId,
      required int depth,
      required String localFileId,
      Value<int?> size,
      Value<String?> hash,
      required bool isFolder,
      Value<String?> mimeType,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required String syncStatus,
      required bool syncEnabled,
      required bool downloadEnabled,
      required String downloadStatus,
      Value<int> rowid,
    });
typedef $$FilesTableUpdateCompanionBuilder =
    FilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentId,
      Value<String?> tempParentId,
      Value<String> ownerId,
      Value<int> depth,
      Value<String> localFileId,
      Value<int?> size,
      Value<String?> hash,
      Value<bool> isFolder,
      Value<String?> mimeType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<bool> syncEnabled,
      Value<bool> downloadEnabled,
      Value<String> downloadStatus,
      Value<int> rowid,
    });

class $$FilesTableFilterComposer extends Composer<_$AppDatabase, $FilesTable> {
  $$FilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempParentId => $composableBuilder(
    column: $table.tempParentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFileId => $composableBuilder(
    column: $table.localFileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFolder => $composableBuilder(
    column: $table.isFolder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get downloadEnabled => $composableBuilder(
    column: $table.downloadEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FilesTableOrderingComposer
    extends Composer<_$AppDatabase, $FilesTable> {
  $$FilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempParentId => $composableBuilder(
    column: $table.tempParentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFileId => $composableBuilder(
    column: $table.localFileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFolder => $composableBuilder(
    column: $table.isFolder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get downloadEnabled => $composableBuilder(
    column: $table.downloadEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FilesTable> {
  $$FilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get tempParentId => $composableBuilder(
    column: $table.tempParentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<int> get depth =>
      $composableBuilder(column: $table.depth, builder: (column) => column);

  GeneratedColumn<String> get localFileId => $composableBuilder(
    column: $table.localFileId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<bool> get isFolder =>
      $composableBuilder(column: $table.isFolder, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get downloadEnabled => $composableBuilder(
    column: $table.downloadEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => column,
  );
}

class $$FilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FilesTable,
          DbFile,
          $$FilesTableFilterComposer,
          $$FilesTableOrderingComposer,
          $$FilesTableAnnotationComposer,
          $$FilesTableCreateCompanionBuilder,
          $$FilesTableUpdateCompanionBuilder,
          (DbFile, BaseReferences<_$AppDatabase, $FilesTable, DbFile>),
          DbFile,
          PrefetchHooks Function()
        > {
  $$FilesTableTableManager(_$AppDatabase db, $FilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> tempParentId = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<int> depth = const Value.absent(),
                Value<String> localFileId = const Value.absent(),
                Value<int?> size = const Value.absent(),
                Value<String?> hash = const Value.absent(),
                Value<bool> isFolder = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> syncEnabled = const Value.absent(),
                Value<bool> downloadEnabled = const Value.absent(),
                Value<String> downloadStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FilesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                tempParentId: tempParentId,
                ownerId: ownerId,
                depth: depth,
                localFileId: localFileId,
                size: size,
                hash: hash,
                isFolder: isFolder,
                mimeType: mimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                syncEnabled: syncEnabled,
                downloadEnabled: downloadEnabled,
                downloadStatus: downloadStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                Value<String?> tempParentId = const Value.absent(),
                required String ownerId,
                required int depth,
                required String localFileId,
                Value<int?> size = const Value.absent(),
                Value<String?> hash = const Value.absent(),
                required bool isFolder,
                Value<String?> mimeType = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String syncStatus,
                required bool syncEnabled,
                required bool downloadEnabled,
                required String downloadStatus,
                Value<int> rowid = const Value.absent(),
              }) => FilesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                tempParentId: tempParentId,
                ownerId: ownerId,
                depth: depth,
                localFileId: localFileId,
                size: size,
                hash: hash,
                isFolder: isFolder,
                mimeType: mimeType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                syncEnabled: syncEnabled,
                downloadEnabled: downloadEnabled,
                downloadStatus: downloadStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FilesTable,
      DbFile,
      $$FilesTableFilterComposer,
      $$FilesTableOrderingComposer,
      $$FilesTableAnnotationComposer,
      $$FilesTableCreateCompanionBuilder,
      $$FilesTableUpdateCompanionBuilder,
      (DbFile, BaseReferences<_$AppDatabase, $FilesTable, DbFile>),
      DbFile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FilesTableTableManager get files =>
      $$FilesTableTableManager(_db, _db.files);
}
