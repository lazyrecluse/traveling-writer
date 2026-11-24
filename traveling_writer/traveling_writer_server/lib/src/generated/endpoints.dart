/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:traveling_writer_server/src/generated/continuity/models/plot_node.dart'
    as _i3jbxbb4;
import 'package:traveling_writer_server/src/generated/continuity/models/world.dart'
    as _i2u7zxad;
import 'package:traveling_writer_server/src/generated/continuity/models/world_entity.dart'
    as _i4b06a8p;
import 'package:traveling_writer_server/src/generated/continuity/models/world_rule.dart'
    as _iq1lqukz;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../continuity/continuity_endpoint.dart' as _iykfnjam;
import '../greetings/greeting_endpoint.dart' as _il624ik7;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'continuity': _iykfnjam.ContinuityEndpoint()
        ..initialize(
          server,
          'continuity',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['continuity'] = _is.EndpointConnector(
      name: 'continuity',
      endpoint: endpoints['continuity']!,
      methodConnectors: {
        'listWorlds': _is.MethodConnector(
          name: 'listWorlds',
          params: {
            'ownerId': _is.ParameterDescription(
              name: 'ownerId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .listWorlds(
                        session,
                        ownerId: params['ownerId'],
                      ),
        ),
        'createWorld': _is.MethodConnector(
          name: 'createWorld',
          params: {
            'world': _is.ParameterDescription(
              name: 'world',
              type: _is.getType<_i2u7zxad.World>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .createWorld(
                        session,
                        params['world'],
                      ),
        ),
        'deleteWorld': _is.MethodConnector(
          name: 'deleteWorld',
          params: {
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .deleteWorld(
                        session,
                        params['worldId'],
                      ),
        ),
        'auditStory': _is.MethodConnector(
          name: 'auditStory',
          params: {
            'storyText': _is.ParameterDescription(
              name: 'storyText',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'chapterId': _is.ParameterDescription(
              name: 'chapterId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .auditStory(
                        session,
                        params['storyText'],
                        worldId: params['worldId'],
                        chapterId: params['chapterId'],
                      ),
        ),
        'listEntities': _is.MethodConnector(
          name: 'listEntities',
          params: {
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .listEntities(
                        session,
                        worldId: params['worldId'],
                      ),
        ),
        'createEntity': _is.MethodConnector(
          name: 'createEntity',
          params: {
            'entity': _is.ParameterDescription(
              name: 'entity',
              type: _is.getType<_i4b06a8p.WorldEntity>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .createEntity(
                        session,
                        params['entity'],
                      ),
        ),
        'deleteEntity': _is.MethodConnector(
          name: 'deleteEntity',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .deleteEntity(
                        session,
                        params['id'],
                        worldId: params['worldId'],
                      ),
        ),
        'listRules': _is.MethodConnector(
          name: 'listRules',
          params: {
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .listRules(
                        session,
                        worldId: params['worldId'],
                      ),
        ),
        'createRule': _is.MethodConnector(
          name: 'createRule',
          params: {
            'rule': _is.ParameterDescription(
              name: 'rule',
              type: _is.getType<_iq1lqukz.WorldRule>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .createRule(
                        session,
                        params['rule'],
                      ),
        ),
        'deleteRule': _is.MethodConnector(
          name: 'deleteRule',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .deleteRule(
                        session,
                        params['id'],
                        worldId: params['worldId'],
                      ),
        ),
        'listPlotNodes': _is.MethodConnector(
          name: 'listPlotNodes',
          params: {
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .listPlotNodes(
                        session,
                        worldId: params['worldId'],
                      ),
        ),
        'savePlotNode': _is.MethodConnector(
          name: 'savePlotNode',
          params: {
            'node': _is.ParameterDescription(
              name: 'node',
              type: _is.getType<_i3jbxbb4.PlotNode>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .savePlotNode(
                        session,
                        params['node'],
                      ),
        ),
        'deletePlotNode': _is.MethodConnector(
          name: 'deletePlotNode',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .deletePlotNode(
                        session,
                        params['id'],
                        worldId: params['worldId'],
                      ),
        ),
        'auditPlotNode': _is.MethodConnector(
          name: 'auditPlotNode',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .auditPlotNode(
                        session,
                        params['id'],
                        worldId: params['worldId'],
                      ),
        ),
        'seedSampleLore': _is.MethodConnector(
          name: 'seedSampleLore',
          params: {
            'worldId': _is.ParameterDescription(
              name: 'worldId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['continuity'] as _iykfnjam.ContinuityEndpoint)
                      .seedSampleLore(
                        session,
                        worldId: params['worldId'],
                      ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
