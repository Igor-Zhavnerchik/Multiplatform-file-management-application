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
  static const VerificationMeta _contentUpdatedAtMeta = const VerificationMeta(
    'contentUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> contentUpdatedAt =
      GeneratedColumn<DateTime>(
        'content_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncStatus>($FilesTable.$convertersyncStatus);
  static const VerificationMeta _contentSyncEnabledMeta =
      const VerificationMeta('contentSyncEnabled');
  @override
  late final GeneratedColumn<bool> contentSyncEnabled = GeneratedColumn<bool>(
    'content_sync_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("content_sync_enabled" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DownloadStatus, String>
  downloadStatus = GeneratedColumn<String>(
    'download_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<DownloadStatus>($FilesTable.$converterdownloadStatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    ownerId,
    localFileId,
    size,
    hash,
    isFolder,
    createdAt,
    updatedAt,
    contentUpdatedAt,
    syncStatus,
    contentSyncEnabled,
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
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
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
    if (data.containsKey('content_updated_at')) {
      context.handle(
        _contentUpdatedAtMeta,
        contentUpdatedAt.isAcceptableOrUnknown(
          data['content_updated_at']!,
          _contentUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentUpdatedAtMeta);
    }
    if (data.containsKey('content_sync_enabled')) {
      context.handle(
        _contentSyncEnabledMeta,
        contentSyncEnabled.isAcceptableOrUnknown(
          data['content_sync_enabled']!,
          _contentSyncEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentSyncEnabledMeta);
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
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      contentUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}content_updated_at'],
      )!,
      syncStatus: $FilesTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      contentSyncEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}content_sync_enabled'],
      )!,
      downloadStatus: $FilesTable.$converterdownloadStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}download_status'],
        )!,
      ),
    );
  }

  @override
  $FilesTable createAlias(String alias) {
    return $FilesTable(attachedDatabase, alias);
  }

  static TypeConverter<SyncStatus, String> $convertersyncStatus =
      SyncStatusConverter();
  static TypeConverter<DownloadStatus, String> $converterdownloadStatus =
      DownloadStatusConverter();
}

class DbFile extends DataClass implements Insertable<DbFile> {
  final String id;
  final String name;
  final String? parentId;
  final String ownerId;
  final String localFileId;
  final int? size;
  final String? hash;
  final bool isFolder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime contentUpdatedAt;
  final SyncStatus syncStatus;
  final bool contentSyncEnabled;
  final DownloadStatus downloadStatus;
  const DbFile({
    required this.id,
    required this.name,
    this.parentId,
    required this.ownerId,
    required this.localFileId,
    this.size,
    this.hash,
    required this.isFolder,
    required this.createdAt,
    required this.updatedAt,
    required this.contentUpdatedAt,
    required this.syncStatus,
    required this.contentSyncEnabled,
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
    map['owner_id'] = Variable<String>(ownerId);
    map['local_file_id'] = Variable<String>(localFileId);
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String>(hash);
    }
    map['is_folder'] = Variable<bool>(isFolder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['content_updated_at'] = Variable<DateTime>(contentUpdatedAt);
    {
      map['sync_status'] = Variable<String>(
        $FilesTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['content_sync_enabled'] = Variable<bool>(contentSyncEnabled);
    {
      map['download_status'] = Variable<String>(
        $FilesTable.$converterdownloadStatus.toSql(downloadStatus),
      );
    }
    return map;
  }

  FilesCompanion toCompanion(bool nullToAbsent) {
    return FilesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      ownerId: Value(ownerId),
      localFileId: Value(localFileId),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
      isFolder: Value(isFolder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      contentUpdatedAt: Value(contentUpdatedAt),
      syncStatus: Value(syncStatus),
      contentSyncEnabled: Value(contentSyncEnabled),
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
      ownerId: serializer.fromJson<String>(json['ownerId']),
      localFileId: serializer.fromJson<String>(json['localFileId']),
      size: serializer.fromJson<int?>(json['size']),
      hash: serializer.fromJson<String?>(json['hash']),
      isFolder: serializer.fromJson<bool>(json['isFolder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      contentUpdatedAt: serializer.fromJson<DateTime>(json['contentUpdatedAt']),
      syncStatus: serializer.fromJson<SyncStatus>(json['syncStatus']),
      contentSyncEnabled: serializer.fromJson<bool>(json['contentSyncEnabled']),
      downloadStatus: serializer.fromJson<DownloadStatus>(
        json['downloadStatus'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'ownerId': serializer.toJson<String>(ownerId),
      'localFileId': serializer.toJson<String>(localFileId),
      'size': serializer.toJson<int?>(size),
      'hash': serializer.toJson<String?>(hash),
      'isFolder': serializer.toJson<bool>(isFolder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'contentUpdatedAt': serializer.toJson<DateTime>(contentUpdatedAt),
      'syncStatus': serializer.toJson<SyncStatus>(syncStatus),
      'contentSyncEnabled': serializer.toJson<bool>(contentSyncEnabled),
      'downloadStatus': serializer.toJson<DownloadStatus>(downloadStatus),
    };
  }

  DbFile copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    String? ownerId,
    String? localFileId,
    Value<int?> size = const Value.absent(),
    Value<String?> hash = const Value.absent(),
    bool? isFolder,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? contentUpdatedAt,
    SyncStatus? syncStatus,
    bool? contentSyncEnabled,
    DownloadStatus? downloadStatus,
  }) => DbFile(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    ownerId: ownerId ?? this.ownerId,
    localFileId: localFileId ?? this.localFileId,
    size: size.present ? size.value : this.size,
    hash: hash.present ? hash.value : this.hash,
    isFolder: isFolder ?? this.isFolder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    contentUpdatedAt: contentUpdatedAt ?? this.contentUpdatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    contentSyncEnabled: contentSyncEnabled ?? this.contentSyncEnabled,
    downloadStatus: downloadStatus ?? this.downloadStatus,
  );
  DbFile copyWithCompanion(FilesCompanion data) {
    return DbFile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      localFileId: data.localFileId.present
          ? data.localFileId.value
          : this.localFileId,
      size: data.size.present ? data.size.value : this.size,
      hash: data.hash.present ? data.hash.value : this.hash,
      isFolder: data.isFolder.present ? data.isFolder.value : this.isFolder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      contentUpdatedAt: data.contentUpdatedAt.present
          ? data.contentUpdatedAt.value
          : this.contentUpdatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      contentSyncEnabled: data.contentSyncEnabled.present
          ? data.contentSyncEnabled.value
          : this.contentSyncEnabled,
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
          ..write('ownerId: $ownerId, ')
          ..write('localFileId: $localFileId, ')
          ..write('size: $size, ')
          ..write('hash: $hash, ')
          ..write('isFolder: $isFolder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('contentUpdatedAt: $contentUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('contentSyncEnabled: $contentSyncEnabled, ')
          ..write('downloadStatus: $downloadStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentId,
    ownerId,
    localFileId,
    size,
    hash,
    isFolder,
    createdAt,
    updatedAt,
    contentUpdatedAt,
    syncStatus,
    contentSyncEnabled,
    downloadStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbFile &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.ownerId == this.ownerId &&
          other.localFileId == this.localFileId &&
          other.size == this.size &&
          other.hash == this.hash &&
          other.isFolder == this.isFolder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.contentUpdatedAt == this.contentUpdatedAt &&
          other.syncStatus == this.syncStatus &&
          other.contentSyncEnabled == this.contentSyncEnabled &&
          other.downloadStatus == this.downloadStatus);
}

class FilesCompanion extends UpdateCompanion<DbFile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<String> ownerId;
  final Value<String> localFileId;
  final Value<int?> size;
  final Value<String?> hash;
  final Value<bool> isFolder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> contentUpdatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<bool> contentSyncEnabled;
  final Value<DownloadStatus> downloadStatus;
  final Value<int> rowid;
  const FilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.localFileId = const Value.absent(),
    this.size = const Value.absent(),
    this.hash = const Value.absent(),
    this.isFolder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.contentUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.contentSyncEnabled = const Value.absent(),
    this.downloadStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FilesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    required String ownerId,
    required String localFileId,
    this.size = const Value.absent(),
    this.hash = const Value.absent(),
    required bool isFolder,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime contentUpdatedAt,
    required SyncStatus syncStatus,
    required bool contentSyncEnabled,
    required DownloadStatus downloadStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       ownerId = Value(ownerId),
       localFileId = Value(localFileId),
       isFolder = Value(isFolder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       contentUpdatedAt = Value(contentUpdatedAt),
       syncStatus = Value(syncStatus),
       contentSyncEnabled = Value(contentSyncEnabled),
       downloadStatus = Value(downloadStatus);
  static Insertable<DbFile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? ownerId,
    Expression<String>? localFileId,
    Expression<int>? size,
    Expression<String>? hash,
    Expression<bool>? isFolder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? contentUpdatedAt,
    Expression<String>? syncStatus,
    Expression<bool>? contentSyncEnabled,
    Expression<String>? downloadStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (ownerId != null) 'owner_id': ownerId,
      if (localFileId != null) 'local_file_id': localFileId,
      if (size != null) 'size': size,
      if (hash != null) 'hash': hash,
      if (isFolder != null) 'is_folder': isFolder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (contentUpdatedAt != null) 'content_updated_at': contentUpdatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (contentSyncEnabled != null)
        'content_sync_enabled': contentSyncEnabled,
      if (downloadStatus != null) 'download_status': downloadStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<String>? ownerId,
    Value<String>? localFileId,
    Value<int?>? size,
    Value<String?>? hash,
    Value<bool>? isFolder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? contentUpdatedAt,
    Value<SyncStatus>? syncStatus,
    Value<bool>? contentSyncEnabled,
    Value<DownloadStatus>? downloadStatus,
    Value<int>? rowid,
  }) {
    return FilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      ownerId: ownerId ?? this.ownerId,
      localFileId: localFileId ?? this.localFileId,
      size: size ?? this.size,
      hash: hash ?? this.hash,
      isFolder: isFolder ?? this.isFolder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentUpdatedAt: contentUpdatedAt ?? this.contentUpdatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      contentSyncEnabled: contentSyncEnabled ?? this.contentSyncEnabled,
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
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (contentUpdatedAt.present) {
      map['content_updated_at'] = Variable<DateTime>(contentUpdatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $FilesTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (contentSyncEnabled.present) {
      map['content_sync_enabled'] = Variable<bool>(contentSyncEnabled.value);
    }
    if (downloadStatus.present) {
      map['download_status'] = Variable<String>(
        $FilesTable.$converterdownloadStatus.toSql(downloadStatus.value),
      );
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
          ..write('ownerId: $ownerId, ')
          ..write('localFileId: $localFileId, ')
          ..write('size: $size, ')
          ..write('hash: $hash, ')
          ..write('isFolder: $isFolder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('contentUpdatedAt: $contentUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('contentSyncEnabled: $contentSyncEnabled, ')
          ..write('downloadStatus: $downloadStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, DbUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultContentSyncMeta =
      const VerificationMeta('defaultContentSync');
  @override
  late final GeneratedColumn<bool> defaultContentSync = GeneratedColumn<bool>(
    'default_content_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("default_content_sync" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, email, defaultContentSync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('default_content_sync')) {
      context.handle(
        _defaultContentSyncMeta,
        defaultContentSync.isAcceptableOrUnknown(
          data['default_content_sync']!,
          _defaultContentSyncMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultContentSyncMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      defaultContentSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}default_content_sync'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class DbUser extends DataClass implements Insertable<DbUser> {
  final String id;
  final String email;
  final bool defaultContentSync;
  const DbUser({
    required this.id,
    required this.email,
    required this.defaultContentSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['default_content_sync'] = Variable<bool>(defaultContentSync);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      defaultContentSync: Value(defaultContentSync),
    );
  }

  factory DbUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbUser(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      defaultContentSync: serializer.fromJson<bool>(json['defaultContentSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'defaultContentSync': serializer.toJson<bool>(defaultContentSync),
    };
  }

  DbUser copyWith({String? id, String? email, bool? defaultContentSync}) =>
      DbUser(
        id: id ?? this.id,
        email: email ?? this.email,
        defaultContentSync: defaultContentSync ?? this.defaultContentSync,
      );
  DbUser copyWithCompanion(UsersCompanion data) {
    return DbUser(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      defaultContentSync: data.defaultContentSync.present
          ? data.defaultContentSync.value
          : this.defaultContentSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbUser(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('defaultContentSync: $defaultContentSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, defaultContentSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbUser &&
          other.id == this.id &&
          other.email == this.email &&
          other.defaultContentSync == this.defaultContentSync);
}

class UsersCompanion extends UpdateCompanion<DbUser> {
  final Value<String> id;
  final Value<String> email;
  final Value<bool> defaultContentSync;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.defaultContentSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required bool defaultContentSync,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       defaultContentSync = Value(defaultContentSync);
  static Insertable<DbUser> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<bool>? defaultContentSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (defaultContentSync != null)
        'default_content_sync': defaultContentSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<bool>? defaultContentSync,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      defaultContentSync: defaultContentSync ?? this.defaultContentSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (defaultContentSync.present) {
      map['default_content_sync'] = Variable<bool>(defaultContentSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('defaultContentSync: $defaultContentSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FilesTable files = $FilesTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final FilesDao filesDao = FilesDao(this as AppDatabase);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [files, users];
}

typedef $$FilesTableCreateCompanionBuilder =
    FilesCompanion Function({
      required String id,
      required String name,
      Value<String?> parentId,
      required String ownerId,
      required String localFileId,
      Value<int?> size,
      Value<String?> hash,
      required bool isFolder,
      required DateTime createdAt,
      required DateTime updatedAt,
      required DateTime contentUpdatedAt,
      required SyncStatus syncStatus,
      required bool contentSyncEnabled,
      required DownloadStatus downloadStatus,
      Value<int> rowid,
    });
typedef $$FilesTableUpdateCompanionBuilder =
    FilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentId,
      Value<String> ownerId,
      Value<String> localFileId,
      Value<int?> size,
      Value<String?> hash,
      Value<bool> isFolder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> contentUpdatedAt,
      Value<SyncStatus> syncStatus,
      Value<bool> contentSyncEnabled,
      Value<DownloadStatus> downloadStatus,
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

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get contentUpdatedAt => $composableBuilder(
    column: $table.contentUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get contentSyncEnabled => $composableBuilder(
    column: $table.contentSyncEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DownloadStatus, DownloadStatus, String>
  get downloadStatus => $composableBuilder(
    column: $table.downloadStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get contentUpdatedAt => $composableBuilder(
    column: $table.contentUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get contentSyncEnabled => $composableBuilder(
    column: $table.contentSyncEnabled,
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

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get contentUpdatedAt => $composableBuilder(
    column: $table.contentUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get contentSyncEnabled => $composableBuilder(
    column: $table.contentSyncEnabled,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DownloadStatus, String> get downloadStatus =>
      $composableBuilder(
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
                Value<String> ownerId = const Value.absent(),
                Value<String> localFileId = const Value.absent(),
                Value<int?> size = const Value.absent(),
                Value<String?> hash = const Value.absent(),
                Value<bool> isFolder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> contentUpdatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> contentSyncEnabled = const Value.absent(),
                Value<DownloadStatus> downloadStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FilesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                ownerId: ownerId,
                localFileId: localFileId,
                size: size,
                hash: hash,
                isFolder: isFolder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                contentUpdatedAt: contentUpdatedAt,
                syncStatus: syncStatus,
                contentSyncEnabled: contentSyncEnabled,
                downloadStatus: downloadStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                required String ownerId,
                required String localFileId,
                Value<int?> size = const Value.absent(),
                Value<String?> hash = const Value.absent(),
                required bool isFolder,
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime contentUpdatedAt,
                required SyncStatus syncStatus,
                required bool contentSyncEnabled,
                required DownloadStatus downloadStatus,
                Value<int> rowid = const Value.absent(),
              }) => FilesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                ownerId: ownerId,
                localFileId: localFileId,
                size: size,
                hash: hash,
                isFolder: isFolder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                contentUpdatedAt: contentUpdatedAt,
                syncStatus: syncStatus,
                contentSyncEnabled: contentSyncEnabled,
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
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String email,
      required bool defaultContentSync,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<bool> defaultContentSync,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get defaultContentSync => $composableBuilder(
    column: $table.defaultContentSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get defaultContentSync => $composableBuilder(
    column: $table.defaultContentSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get defaultContentSync => $composableBuilder(
    column: $table.defaultContentSync,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          DbUser,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (DbUser, BaseReferences<_$AppDatabase, $UsersTable, DbUser>),
          DbUser,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<bool> defaultContentSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                defaultContentSync: defaultContentSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required bool defaultContentSync,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                defaultContentSync: defaultContentSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      DbUser,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (DbUser, BaseReferences<_$AppDatabase, $UsersTable, DbUser>),
      DbUser,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FilesTableTableManager get files =>
      $$FilesTableTableManager(_db, _db.files);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
