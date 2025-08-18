class CloudinaryResponse {
  final String assetId;
  final String publicId;
  final int version;
  final String versionId;
  final String signature;
  final String resourceType;
  final String createdAt;
  final List<String> tags;
  final int bytes;
  final String type;
  final String etag;
  final bool placeholder;
  final String url;

  final String assetFolder;
  final String displayName;
  final String originalFilename;
  final String apiKey;
  final String? signedUrl;

  CloudinaryResponse({
    required this.assetId,
    required this.publicId,
    required this.version,
    required this.versionId,
    required this.signature,
    required this.resourceType,
    required this.createdAt,
    required this.tags,
    required this.bytes,
    required this.type,
    required this.etag,
    required this.placeholder,
    required this.url,

    required this.assetFolder,
    required this.displayName,
    required this.originalFilename,
    required this.apiKey,
    this.signedUrl,
  });

  factory CloudinaryResponse.fromJson(Map<String, dynamic> json) {
    return CloudinaryResponse(
      assetId: json['asset_id'] as String? ?? "",
      publicId: json['public_id'] as String? ?? "",
      version: json['version'] as int? ?? 1,
      versionId: json['version_id'] as String? ?? "",
      signature: json['signature'] as String? ?? "",
      resourceType: json['resource_type'] as String? ?? "",
      createdAt: json['created_at'] as String? ?? "",
      tags: List<String>.from(json['tags'] as List? ?? []),
      bytes: json['bytes'] as int? ?? 1,
      type: json['type'] as String? ?? "",
      etag: json['etag'] as String? ?? "",
      placeholder: json['placeholder'] as bool? ?? false,
      url: json['url'] as String? ?? "",

      assetFolder: json['asset_folder'] as String? ?? "",
      displayName: json['display_name'] as String? ?? "",
      originalFilename: json['original_filename'] as String? ?? "",
      apiKey: json['api_key'] as String? ?? "",
      signedUrl: json['signed_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_id': assetId,
      'public_id': publicId,
      'version': version,
      'version_id': versionId,
      'signature': signature,
      'resource_type': resourceType,
      'created_at': createdAt,
      'tags': tags,
      'bytes': bytes,
      'type': type,
      'etag': etag,
      'placeholder': placeholder,
      'url': url,

      'asset_folder': assetFolder,
      'display_name': displayName,
      'original_filename': originalFilename,
      'api_key': apiKey,
      'signed_url': signedUrl,
    };
  }

  String get effectiveUrl => url;
}
