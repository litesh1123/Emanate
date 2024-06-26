import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/new_follower_notification_widget.dart';
import '/components/todaytomonthnotification_followers_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));

      await currentUserReference!.update({
        ...mapToFirestore(
          {
            'unreadNotifications': FieldValue.delete(),
          },
        ),
      });
    });

    if (!isWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    if (!isWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pop();
            },
            child: const Icon(
              FFIcons.karrowLeft,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          title: Text(
            'Notifications',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if ((currentUserDocument?.unreadNotifications
                                        .toList() ??
                                    []).isNotEmpty)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: AuthUserStreamWidget(
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 18.0),
                                    child: Text(
                                      'New',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final unreadNotifications = functions
                                                .reverseList((currentUserDocument
                                                            ?.unreadNotifications
                                                            .toList() ??
                                                        [])
                                                    .toList())
                                                ?.toList() ??
                                            [];
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              unreadNotifications.length,
                                              (unreadNotificationsIndex) {
                                            final unreadNotificationsItem =
                                                unreadNotifications[
                                                    unreadNotificationsIndex];
                                            return Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: StreamBuilder<
                                                  NotificationsRecord>(
                                                stream: NotificationsRecord
                                                    .getDocument(
                                                        unreadNotificationsItem),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return const Center(
                                                      child: SizedBox(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final columnNotificationsRecord =
                                                      snapshot.data!;
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Follow')
                                                        NewFollowerNotificationWidget(
                                                          key: Key(
                                                              'Keybwt_${unreadNotificationsIndex}_of_${unreadNotifications.length}'),
                                                          notification:
                                                              columnNotificationsRecord,
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'PostDetails',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: custom_widgets
                                                                          .Notifications(
                                                                        width:
                                                                            400.0,
                                                                        height:
                                                                            50.0,
                                                                        name: valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .username,
                                                                          'user',
                                                                        ),
                                                                        notification:
                                                                            'liked your post.',
                                                                        time: valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            'relative',
                                                                            columnNotificationsRecord.timeCreated,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'now',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Comment_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'liked your comment: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Tagged_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on a post you are tagged in: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on your post: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 0.5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDADADA),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: StreamBuilder<List<NotificationsRecord>>(
                            stream: queryNotificationsRecord(
                              parent: currentUserReference,
                              queryBuilder: (notificationsRecord) =>
                                  notificationsRecord.where(
                                'time_created',
                                isGreaterThan: functions
                                    .returnThisMorning(getCurrentTimestamp),
                              ),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<NotificationsRecord>
                                  columnNotificationsRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final columnNotificationsRecord =
                                  columnNotificationsRecordList.isNotEmpty
                                      ? columnNotificationsRecordList.first
                                      : null;
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 18.0),
                                    child: Text(
                                      'Today',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 0.0),
                                    child: StreamBuilder<
                                        List<NotificationsRecord>>(
                                      stream: queryNotificationsRecord(
                                        parent: currentUserReference,
                                        queryBuilder: (notificationsRecord) =>
                                            notificationsRecord
                                                .where(
                                                  'time_created',
                                                  isGreaterThan: functions
                                                      .returnThisMorning(
                                                          getCurrentTimestamp),
                                                )
                                                .orderBy('time_created',
                                                    descending: true),
                                        limit: 10,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: SizedBox(
                                              width: 12.0,
                                              height: 12.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<NotificationsRecord>
                                            columnNotificationsRecordList =
                                            snapshot.data!;
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              columnNotificationsRecordList
                                                  .length, (columnIndex) {
                                            final columnNotificationsRecord =
                                                columnNotificationsRecordList[
                                                    columnIndex];
                                            return Visibility(
                                              visible: !(currentUserDocument
                                                          ?.unreadNotifications
                                                          .toList() ??
                                                      [])
                                                  .contains(
                                                      columnNotificationsRecord
                                                          .reference),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: AuthUserStreamWidget(
                                                  builder: (context) => Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Follow')
                                                        TodaytomonthnotificationFollowersWidget(
                                                          key: Key(
                                                              'Keyr8x_${columnIndex}_of_${columnNotificationsRecordList.length}'),
                                                          notification:
                                                              columnNotificationsRecord,
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'PostDetails',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: custom_widgets
                                                                          .Notifications(
                                                                        width:
                                                                            400.0,
                                                                        height:
                                                                            50.0,
                                                                        name: valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .username,
                                                                          'user',
                                                                        ),
                                                                        notification:
                                                                            'liked your post.',
                                                                        time: valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            'relative',
                                                                            columnNotificationsRecord.timeCreated,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'now',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Comment_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'liked your comment: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Tagged_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on a post you are tagged in: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on your post: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 0.5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDADADA),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: StreamBuilder<List<NotificationsRecord>>(
                            stream: queryNotificationsRecord(
                              parent: currentUserReference,
                              queryBuilder: (notificationsRecord) =>
                                  notificationsRecord
                                      .where(
                                        'time_created',
                                        isGreaterThan: functions.returnThisWeek(
                                            getCurrentTimestamp),
                                      )
                                      .where(
                                        'time_created',
                                        isLessThan: functions.returnThisMorning(
                                            getCurrentTimestamp),
                                      ),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<NotificationsRecord>
                                  columnNotificationsRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final columnNotificationsRecord =
                                  columnNotificationsRecordList.isNotEmpty
                                      ? columnNotificationsRecordList.first
                                      : null;
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 18.0),
                                    child: Text(
                                      'This Week',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 0.0),
                                    child: StreamBuilder<
                                        List<NotificationsRecord>>(
                                      stream: queryNotificationsRecord(
                                        parent: currentUserReference,
                                        queryBuilder: (notificationsRecord) =>
                                            notificationsRecord
                                                .where(
                                                  'time_created',
                                                  isGreaterThan:
                                                      functions.returnThisWeek(
                                                          getCurrentTimestamp),
                                                )
                                                .where(
                                                  'time_created',
                                                  isLessThan: functions
                                                      .returnThisMorning(
                                                          getCurrentTimestamp),
                                                )
                                                .orderBy('time_created',
                                                    descending: true),
                                        limit: 10,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: SizedBox(
                                              width: 12.0,
                                              height: 12.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<NotificationsRecord>
                                            columnNotificationsRecordList =
                                            snapshot.data!;
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              columnNotificationsRecordList
                                                  .length, (columnIndex) {
                                            final columnNotificationsRecord =
                                                columnNotificationsRecordList[
                                                    columnIndex];
                                            return Visibility(
                                              visible: !(currentUserDocument
                                                          ?.unreadNotifications
                                                          .toList() ??
                                                      [])
                                                  .contains(
                                                      columnNotificationsRecord
                                                          .reference),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: AuthUserStreamWidget(
                                                  builder: (context) => Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Follow')
                                                        TodaytomonthnotificationFollowersWidget(
                                                          key: Key(
                                                              'Key8g8_${columnIndex}_of_${columnNotificationsRecordList.length}'),
                                                          notification:
                                                              columnNotificationsRecord,
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'PostDetails',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: custom_widgets
                                                                          .Notifications(
                                                                        width:
                                                                            400.0,
                                                                        height:
                                                                            50.0,
                                                                        name: valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .username,
                                                                          'user',
                                                                        ),
                                                                        notification:
                                                                            'liked your post.',
                                                                        time: valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            'relative',
                                                                            columnNotificationsRecord.timeCreated,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'now',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Comment_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'liked your comment: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Tagged_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on a post you are tagged in: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on your post: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 0.5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDADADA),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: StreamBuilder<List<NotificationsRecord>>(
                            stream: queryNotificationsRecord(
                              parent: currentUserReference,
                              queryBuilder: (notificationsRecord) =>
                                  notificationsRecord
                                      .where(
                                        'time_created',
                                        isGreaterThan:
                                            functions.returnThisMonth(
                                                getCurrentTimestamp),
                                      )
                                      .where(
                                        'time_created',
                                        isLessThan: functions.returnThisWeek(
                                            getCurrentTimestamp),
                                      ),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<NotificationsRecord>
                                  columnNotificationsRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final columnNotificationsRecord =
                                  columnNotificationsRecordList.isNotEmpty
                                      ? columnNotificationsRecordList.first
                                      : null;
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 18.0),
                                    child: Text(
                                      'This Month',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 0.0),
                                    child: StreamBuilder<
                                        List<NotificationsRecord>>(
                                      stream: queryNotificationsRecord(
                                        parent: currentUserReference,
                                        queryBuilder: (notificationsRecord) =>
                                            notificationsRecord
                                                .where(
                                                  'time_created',
                                                  isGreaterThan:
                                                      functions.returnThisMonth(
                                                          getCurrentTimestamp),
                                                )
                                                .where(
                                                  'time_created',
                                                  isLessThan:
                                                      functions.returnThisWeek(
                                                          getCurrentTimestamp),
                                                )
                                                .orderBy('time_created',
                                                    descending: true),
                                        limit: 10,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: SizedBox(
                                              width: 12.0,
                                              height: 12.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<NotificationsRecord>
                                            columnNotificationsRecordList =
                                            snapshot.data!;
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              columnNotificationsRecordList
                                                  .length, (columnIndex) {
                                            final columnNotificationsRecord =
                                                columnNotificationsRecordList[
                                                    columnIndex];
                                            return Visibility(
                                              visible: !(currentUserDocument
                                                          ?.unreadNotifications
                                                          .toList() ??
                                                      [])
                                                  .contains(
                                                      columnNotificationsRecord
                                                          .reference),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: AuthUserStreamWidget(
                                                  builder: (context) => Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Follow')
                                                        TodaytomonthnotificationFollowersWidget(
                                                          key: Key(
                                                              'Keyudq_${columnIndex}_of_${columnNotificationsRecordList.length}'),
                                                          notification:
                                                              columnNotificationsRecord,
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'PostDetails',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: custom_widgets
                                                                          .Notifications(
                                                                        width:
                                                                            400.0,
                                                                        height:
                                                                            50.0,
                                                                        name: valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .username,
                                                                          'user',
                                                                        ),
                                                                        notification:
                                                                            'liked your post.',
                                                                        time: valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            'relative',
                                                                            columnNotificationsRecord.timeCreated,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'now',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Comment_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'liked your comment: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Tagged_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on a post you are tagged in: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on your post: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 0.5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDADADA),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: StreamBuilder<List<NotificationsRecord>>(
                            stream: queryNotificationsRecord(
                              parent: currentUserReference,
                              queryBuilder: (notificationsRecord) =>
                                  notificationsRecord.where(
                                'time_created',
                                isLessThan: functions
                                    .returnThisMonth(getCurrentTimestamp),
                              ),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<NotificationsRecord>
                                  columnNotificationsRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final columnNotificationsRecord =
                                  columnNotificationsRecordList.isNotEmpty
                                      ? columnNotificationsRecordList.first
                                      : null;
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 18.0),
                                    child: Text(
                                      'Earlier',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        15.0, 0.0, 15.0, 0.0),
                                    child: StreamBuilder<
                                        List<NotificationsRecord>>(
                                      stream: queryNotificationsRecord(
                                        parent: currentUserReference,
                                        queryBuilder: (notificationsRecord) =>
                                            notificationsRecord
                                                .where(
                                                  'time_created',
                                                  isLessThan:
                                                      functions.returnThisMonth(
                                                          getCurrentTimestamp),
                                                )
                                                .orderBy('time_created',
                                                    descending: true),
                                        limit: 10,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: SizedBox(
                                              width: 12.0,
                                              height: 12.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<NotificationsRecord>
                                            columnNotificationsRecordList =
                                            snapshot.data!;
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              columnNotificationsRecordList
                                                  .length, (columnIndex) {
                                            final columnNotificationsRecord =
                                                columnNotificationsRecordList[
                                                    columnIndex];
                                            return Visibility(
                                              visible: !(currentUserDocument
                                                          ?.unreadNotifications
                                                          .toList() ??
                                                      [])
                                                  .contains(
                                                      columnNotificationsRecord
                                                          .reference),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 12.0),
                                                child: AuthUserStreamWidget(
                                                  builder: (context) => Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Follow')
                                                        TodaytomonthnotificationFollowersWidget(
                                                          key: Key(
                                                              'Keyki4_${columnIndex}_of_${columnNotificationsRecordList.length}'),
                                                          notification:
                                                              columnNotificationsRecord,
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'PostDetails',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: custom_widgets
                                                                          .Notifications(
                                                                        width:
                                                                            400.0,
                                                                        height:
                                                                            50.0,
                                                                        name: valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .username,
                                                                          'user',
                                                                        ),
                                                                        notification:
                                                                            'liked your post.',
                                                                        time: valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            'relative',
                                                                            columnNotificationsRecord.timeCreated,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'now',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Comment_Like')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'liked your comment: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Tagged_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on a post you are tagged in: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (columnNotificationsRecord
                                                              .notificationType ==
                                                          'Post_Comment')
                                                        StreamBuilder<
                                                            UsersRecord>(
                                                          stream: UsersRecord
                                                              .getDocument(
                                                                  columnNotificationsRecord
                                                                      .userRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 12.0,
                                                                  height: 12.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final rowUsersRecord =
                                                                snapshot.data!;
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                context
                                                                    .pushNamed(
                                                                  'Comments',
                                                                  queryParameters:
                                                                      {
                                                                    'post':
                                                                        serializeParam(
                                                                      columnNotificationsRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          45.0,
                                                                      height:
                                                                          45.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          rowUsersRecord
                                                                              .photoUrl,
                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                                      child: StreamBuilder<
                                                                          CommentsRecord>(
                                                                        stream:
                                                                            CommentsRecord.getDocument(columnNotificationsRecord.commentRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 12.0,
                                                                                height: 12.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final notificationsCommentsRecord =
                                                                              snapshot.data!;
                                                                          return custom_widgets
                                                                              .Notifications(
                                                                            width:
                                                                                400.0,
                                                                            height:
                                                                                50.0,
                                                                            name:
                                                                                valueOrDefault<String>(
                                                                              rowUsersRecord.username,
                                                                              'user',
                                                                            ),
                                                                            notification:
                                                                                'commented on your post: ${notificationsCommentsRecord.comment}',
                                                                            time:
                                                                                valueOrDefault<String>(
                                                                              dateTimeFormat(
                                                                                'relative',
                                                                                columnNotificationsRecord.timeCreated,
                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                              ),
                                                                              'now',
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<
                                                                      PostsRecord>(
                                                                    stream: PostsRecord.getDocument(
                                                                        columnNotificationsRecord
                                                                            .postRef!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return const Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                12.0,
                                                                            height:
                                                                                12.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final imagePostsRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Image
                                                                          .network(
                                                                        imagePostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 0.5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDADADA),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!(isWeb
                  ? MediaQuery.viewInsetsOf(context).bottom > 0
                  : _isKeyboardVisible))
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDADADA),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      HapticFeedback.lightImpact();

                                      context.pushNamed(
                                        'Feed',
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: const TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration: Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FFIcons.khome1,
                                            color: Colors.black,
                                            size: 28.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      HapticFeedback.lightImpact();

                                      context.pushNamed(
                                        'Search',
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: const TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration: Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 55.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 1.0),
                                            child: Icon(
                                              FFIcons.ksearch,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 26.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      HapticFeedback.lightImpact();

                                      context.pushNamed(
                                        'Profile',
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: const TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration: Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 55.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment:
                                                const AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              Container(
                                                width: 36.0,
                                                height: 36.0,
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Align(
                                                alignment: const AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: AuthUserStreamWidget(
                                                  builder: (context) =>
                                                      Container(
                                                    width: 33.0,
                                                    height: 33.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            currentUserPhoto,
                                                            'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                          ),
                                                        ).image,
                                                      ),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
