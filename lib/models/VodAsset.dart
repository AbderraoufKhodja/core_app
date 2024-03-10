// /*
// * Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// *
// * Licensed under the Apache License, Version 2.0 (the "License").
// * You may not use this file except in compliance with the License.
// * A copy of the License is located at
// *
// *  http://aws.amazon.com/apache2.0
// *
// * or in the "license" file accompanying this file. This file is distributed
// * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// * express or implied. See the License for the specific language governing
// * permissions and limitations under the License.
// */

// // NOTE: This file is generated and may not follow lint rules defined in your app
// // Generated files can be excluded from analysis in analysis_options.yaml
// // For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// // ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

// import 'ModelProvider.dart';
// import 'package:amplify_core/amplify_core.dart' as amplify_core;


// /** This is an auto generated class representing the VodAsset type in your schema. */
// class VodAsset extends amplify_core.Model {
//   static const classType = const _VodAssetModelType();
//   final String id;
//   final String? _title;
//   final String? _description;
//   final VideoObject? _video;
//   final amplify_core.TemporalDateTime? _createdAt;
//   final amplify_core.TemporalDateTime? _updatedAt;
//   final String? _vodAssetVideoId;

//   @override
//   getInstanceType() => classType;
  
//   @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
//   @override
//   String getId() => id;
  
//   VodAssetModelIdentifier get modelIdentifier {
//       return VodAssetModelIdentifier(
//         id: id
//       );
//   }
  
//   String get title {
//     try {
//       return _title!;
//     } catch(e) {
//       throw amplify_core.AmplifyCodeGenModelException(
//           amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
//           recoverySuggestion:
//             amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
//           underlyingException: e.toString()
//           );
//     }
//   }
  
//   String get description {
//     try {
//       return _description!;
//     } catch(e) {
//       throw amplify_core.AmplifyCodeGenModelException(
//           amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
//           recoverySuggestion:
//             amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
//           underlyingException: e.toString()
//           );
//     }
//   }
  
//   VideoObject? get video {
//     return _video;
//   }
  
//   amplify_core.TemporalDateTime? get createdAt {
//     return _createdAt;
//   }
  
//   amplify_core.TemporalDateTime? get updatedAt {
//     return _updatedAt;
//   }
  
//   String? get vodAssetVideoId {
//     return _vodAssetVideoId;
//   }
  
//   const VodAsset._internal({required this.id, required title, required description, video, createdAt, updatedAt, vodAssetVideoId}): _title = title, _description = description, _video = video, _createdAt = createdAt, _updatedAt = updatedAt, _vodAssetVideoId = vodAssetVideoId;
  
//   factory VodAsset({String? id, required String title, required String description, VideoObject? video, String? vodAssetVideoId}) {
//     return VodAsset._internal(
//       id: id == null ? amplify_core.UUID.getUUID() : id,
//       title: title,
//       description: description,
//       video: video,
//       vodAssetVideoId: vodAssetVideoId);
//   }
  
//   bool equals(Object other) {
//     return this == other;
//   }
  
//   @override
//   bool operator ==(Object other) {
//     if (identical(other, this)) return true;
//     return other is VodAsset &&
//       id == other.id &&
//       _title == other._title &&
//       _description == other._description &&
//       _video == other._video &&
//       _vodAssetVideoId == other._vodAssetVideoId;
//   }
  
//   @override
//   int get hashCode => toString().hashCode;
  
//   @override
//   String toString() {
//     var buffer = new StringBuffer();
    
//     buffer.write("VodAsset {");
//     buffer.write("id=" + "$id" + ", ");
//     buffer.write("title=" + "$_title" + ", ");
//     buffer.write("description=" + "$_description" + ", ");
//     buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
//     buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
//     buffer.write("vodAssetVideoId=" + "$_vodAssetVideoId");
//     buffer.write("}");
    
//     return buffer.toString();
//   }
  
//   VodAsset copyWith({String? title, String? description, VideoObject? video, String? vodAssetVideoId}) {
//     return VodAsset._internal(
//       id: id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       video: video ?? this.video,
//       vodAssetVideoId: vodAssetVideoId ?? this.vodAssetVideoId);
//   }
  
//   VodAsset copyWithModelFieldValues({
//     ModelFieldValue<String>? title,
//     ModelFieldValue<String>? description,
//     ModelFieldValue<VideoObject?>? video,
//     ModelFieldValue<String?>? vodAssetVideoId
//   }) {
//     return VodAsset._internal(
//       id: id,
//       title: title == null ? this.title : title.value,
//       description: description == null ? this.description : description.value,
//       video: video == null ? this.video : video.value,
//       vodAssetVideoId: vodAssetVideoId == null ? this.vodAssetVideoId : vodAssetVideoId.value
//     );
//   }
  
//   VodAsset.fromJson(Map<String, dynamic> json)  
//     : id = json['id'],
//       _title = json['title'],
//       _description = json['description'],
//       _video = json['video']?['serializedData'] != null
//         ? VideoObject.fromJson(new Map<String, dynamic>.from(json['video']['serializedData']))
//         : null,
//       _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
//       _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
//       _vodAssetVideoId = json['vodAssetVideoId'];
  
//   Map<String, dynamic> toJson() => {
//     'id': id, 'title': _title, 'description': _description, 'video': _video?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'vodAssetVideoId': _vodAssetVideoId
//   };
  
//   Map<String, Object?> toMap() => {
//     'id': id,
//     'title': _title,
//     'description': _description,
//     'video': _video,
//     'createdAt': _createdAt,
//     'updatedAt': _updatedAt,
//     'vodAssetVideoId': _vodAssetVideoId
//   };

//   static final amplify_core.QueryModelIdentifier<VodAssetModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<VodAssetModelIdentifier>();
//   static final ID = amplify_core.QueryField(fieldName: "id");
//   static final TITLE = amplify_core.QueryField(fieldName: "title");
//   static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
//   static final VIDEO = amplify_core.QueryField(
//     fieldName: "video",
//     fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'VideoObject'));
//   static final VODASSETVIDEOID = amplify_core.QueryField(fieldName: "vodAssetVideoId");
//   static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
//     modelSchemaDefinition.name = "VodAsset";
//     modelSchemaDefinition.pluralName = "VodAssets";
    
//     modelSchemaDefinition.authRules = [
//       amplify_core.AuthRule(
//         authStrategy: amplify_core.AuthStrategy.GROUPS,
//         groupClaim: "cognito:groups",
//         groups: [ "Admin" ],
//         provider: amplify_core.AuthRuleProvider.USERPOOLS,
//         operations: const [
//           amplify_core.ModelOperation.CREATE,
//           amplify_core.ModelOperation.UPDATE,
//           amplify_core.ModelOperation.DELETE,
//           amplify_core.ModelOperation.READ
//         ]),
//       amplify_core.AuthRule(
//         authStrategy: amplify_core.AuthStrategy.PRIVATE,
//         operations: const [
//           amplify_core.ModelOperation.READ
//         ])
//     ];
    
//     modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
//     modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
//       key: VodAsset.TITLE,
//       isRequired: true,
//       ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
//     ));
    
//     modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
//       key: VodAsset.DESCRIPTION,
//       isRequired: true,
//       ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
//     ));
    
//     modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
//       key: VodAsset.VIDEO,
//       isRequired: false,
//       ofModelName: 'VideoObject',
//       associatedKey: VideoObject.ID
//     ));
    
//     modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
//       fieldName: 'createdAt',
//       isRequired: false,
//       isReadOnly: true,
//       ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
//     ));
    
//     modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
//       fieldName: 'updatedAt',
//       isRequired: false,
//       isReadOnly: true,
//       ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
//     ));
    
//     modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
//       key: VodAsset.VODASSETVIDEOID,
//       isRequired: false,
//       ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
//     ));
//   });
// }

// class _VodAssetModelType extends amplify_core.ModelType<VodAsset> {
//   const _VodAssetModelType();
  
//   @override
//   VodAsset fromJson(Map<String, dynamic> jsonData) {
//     return VodAsset.fromJson(jsonData);
//   }
  
//   @override
//   String modelName() {
//     return 'VodAsset';
//   }
// }

// /**
//  * This is an auto generated class representing the model identifier
//  * of [VodAsset] in your schema.
//  */
// class VodAssetModelIdentifier implements amplify_core.ModelIdentifier<VodAsset> {
//   final String id;

//   /** Create an instance of VodAssetModelIdentifier using [id] the primary key. */
//   const VodAssetModelIdentifier({
//     required this.id});
  
//   @override
//   Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
//     'id': id
//   });
  
//   @override
//   List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
//     .entries
//     .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
//     .toList();
  
//   @override
//   String serializeAsString() => serializeAsMap().values.join('#');
  
//   @override
//   String toString() => 'VodAssetModelIdentifier(id: $id)';
  
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
    
//     return other is VodAssetModelIdentifier &&
//       id == other.id;
//   }
  
//   @override
//   int get hashCode =>
//     id.hashCode;
// }