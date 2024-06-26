import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'individual_message_model.dart';
export 'individual_message_model.dart';

class IndividualMessageWidget extends StatefulWidget {
  const IndividualMessageWidget({
    super.key,
    this.chat,
  });

  final DocumentReference? chat;

  @override
  State<IndividualMessageWidget> createState() =>
      _IndividualMessageWidgetState();
}

class _IndividualMessageWidgetState extends State<IndividualMessageWidget> {
  late IndividualMessageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IndividualMessageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await widget.chat!.update({
        ...mapToFirestore(
          {
            'last_message_seen_by':
                FieldValue.arrayUnion([currentUserReference]),
          },
        ),
      });
    });

    _model.messageTextController ??= TextEditingController();
    _model.messageFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

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
          automaticallyImplyLeading: false,
          title: StreamBuilder<ChatsRecord>(
            stream: ChatsRecord.getDocument(widget.chat!),
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
              final rowChatsRecord = snapshot.data!;
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(
                        'Messages',
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.leftToRight,
                          ),
                        },
                      );
                    },
                    child: const Icon(
                      FFIcons.karrowLeft,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                    child: StreamBuilder<UsersRecord>(
                      stream: UsersRecord.getDocument(
                          rowChatsRecord.userA == currentUserReference
                              ? rowChatsRecord.userB!
                              : rowChatsRecord.userA!),
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
                        final usernameUsersRecord = snapshot.data!;
                        return Text(
                          usernameUsersRecord.username,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                  ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await widget.chat!.delete();
                    },
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.black,
                      size: 26.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 0.5,
                decoration: const BoxDecoration(
                  color: Color(0xFFDADADA),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Stack(
                    alignment: const AlignmentDirectional(0.0, 1.0),
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 100.0),
                          child: StreamBuilder<List<ChatMessagesRecord>>(
                            stream: queryChatMessagesRecord(
                              queryBuilder: (chatMessagesRecord) =>
                                  chatMessagesRecord
                                      .where(
                                        'chat',
                                        isEqualTo: widget.chat,
                                      )
                                      .orderBy('timestamp', descending: true),
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
                              List<ChatMessagesRecord>
                                  messageChatMessagesRecordList =
                                  snapshot.data!;
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                reverse: true,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: messageChatMessagesRecordList.length,
                                itemBuilder: (context, messageIndex) {
                                  final messageChatMessagesRecord =
                                      messageChatMessagesRecordList[
                                          messageIndex];
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      if (messageChatMessagesRecord.user ==
                                          currentUserReference)
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.75,
                                                decoration: const BoxDecoration(),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          1.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      if ((messageChatMessagesRecord
                                                                  .postRef ==
                                                              null) &&
                                                          (messageChatMessagesRecord
                                                                  .commentRef ==
                                                              null))
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFF444AFB),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              32.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              8.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              32.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            10.0,
                                                                            16.0,
                                                                            10.0),
                                                                    child: Text(
                                                                      messageChatMessagesRecord
                                                                          .text,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                15.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            lineHeight:
                                                                                1.5,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      if ((messageChatMessagesRecord
                                                                  .postRef !=
                                                              null) &&
                                                          (messageChatMessagesRecord
                                                                  .commentRef !=
                                                              null))
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            context.pushNamed(
                                                              'PostDetails',
                                                              queryParameters: {
                                                                'post':
                                                                    serializeParam(
                                                                  messageChatMessagesRecord
                                                                      .postRef,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    1.0, 1.0),
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            20.0),
                                                                child: StreamBuilder<
                                                                    PostsRecord>(
                                                                  stream: PostsRecord
                                                                      .getDocument(
                                                                          messageChatMessagesRecord
                                                                              .postRef!),
                                                                  builder: (context,
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
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final postPhotoPostsRecord =
                                                                        snapshot
                                                                            .data!;
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                      child: Image
                                                                          .network(
                                                                        postPhotoPostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            200.0,
                                                                        height:
                                                                            200.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            24.0,
                                                                            0.0),
                                                                child: StreamBuilder<
                                                                    CommentsRecord>(
                                                                  stream: CommentsRecord
                                                                      .getDocument(
                                                                          messageChatMessagesRecord
                                                                              .commentRef!),
                                                                  builder: (context,
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
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final postCommentCommentsRecord =
                                                                        snapshot
                                                                            .data!;
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFF5F5F5),
                                                                            borderRadius:
                                                                                BorderRadius.circular(16.0),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: FutureBuilder<UsersRecord>(
                                                                                    future: UsersRecord.getDocumentOnce(postCommentCommentsRecord.postUser!),
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
                                                                                      final rowUsersRecord = snapshot.data!;
                                                                                      return Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Align(
                                                                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                focusColor: Colors.transparent,
                                                                                                hoverColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                onTap: () async {
                                                                                                  if (rowUsersRecord.reference == currentUserReference) {
                                                                                                    context.pushNamed('Profile');
                                                                                                  } else {
                                                                                                    context.pushNamed(
                                                                                                      'ProfileOther',
                                                                                                      queryParameters: {
                                                                                                        'username': serializeParam(
                                                                                                          rowUsersRecord.username,
                                                                                                          ParamType.String,
                                                                                                        ),
                                                                                                      }.withoutNulls,
                                                                                                    );
                                                                                                  }
                                                                                                },
                                                                                                child: Container(
                                                                                                  width: 37.0,
                                                                                                  height: 37.0,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                    image: DecorationImage(
                                                                                                      fit: BoxFit.cover,
                                                                                                      image: Image.network(
                                                                                                        valueOrDefault<String>(
                                                                                                          rowUsersRecord.photoUrl,
                                                                                                          'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                                                        ),
                                                                                                      ).image,
                                                                                                    ),
                                                                                                    shape: BoxShape.circle,
                                                                                                    border: Border.all(
                                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                                      width: 2.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 9.0, 0.0, 0.0),
                                                                                                  child: InkWell(
                                                                                                    splashColor: Colors.transparent,
                                                                                                    focusColor: Colors.transparent,
                                                                                                    hoverColor: Colors.transparent,
                                                                                                    highlightColor: Colors.transparent,
                                                                                                    onTap: () async {
                                                                                                      if (rowUsersRecord.reference == currentUserReference) {
                                                                                                        context.pushNamed('Profile');
                                                                                                      } else {
                                                                                                        context.pushNamed(
                                                                                                          'ProfileOther',
                                                                                                          queryParameters: {
                                                                                                            'username': serializeParam(
                                                                                                              rowUsersRecord.username,
                                                                                                              ParamType.String,
                                                                                                            ),
                                                                                                          }.withoutNulls,
                                                                                                        );
                                                                                                      }
                                                                                                    },
                                                                                                    child: custom_widgets.PhotoCaption(
                                                                                                      width: double.infinity,
                                                                                                      height: 17.0,
                                                                                                      name: valueOrDefault<String>(
                                                                                                        rowUsersRecord.username,
                                                                                                        'user',
                                                                                                      ),
                                                                                                      caption: postCommentCommentsRecord.comment,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
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
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      if ((messageChatMessagesRecord
                                                                  .postRef !=
                                                              null) &&
                                                          (messageChatMessagesRecord
                                                                  .commentRef ==
                                                              null))
                                                        StreamBuilder<
                                                            PostsRecord>(
                                                          stream: PostsRecord
                                                              .getDocument(
                                                                  messageChatMessagesRecord
                                                                      .postRef!),
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
                                                            final photoSharingPostPostsRecord =
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
                                                                      messageChatMessagesRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFFF5F5F5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16.0),
                                                                ),
                                                                child: FutureBuilder<
                                                                    UsersRecord>(
                                                                  future: UsersRecord
                                                                      .getDocumentOnce(
                                                                          photoSharingPostPostsRecord
                                                                              .postUser!),
                                                                  builder: (context,
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
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final columnUsersRecord =
                                                                        snapshot
                                                                            .data!;
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              16.0,
                                                                              8.0,
                                                                              16.0,
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                  child: Container(
                                                                                    width: 37.0,
                                                                                    height: 37.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      image: DecorationImage(
                                                                                        fit: BoxFit.cover,
                                                                                        image: Image.network(
                                                                                          valueOrDefault<String>(
                                                                                            columnUsersRecord.photoUrl,
                                                                                            'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                                          ),
                                                                                        ).image,
                                                                                      ),
                                                                                      shape: BoxShape.circle,
                                                                                      border: Border.all(
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        width: 2.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                columnUsersRecord.username.maybeHandleOverflow(
                                                                                  maxChars: 26,
                                                                                  replacement: '…',
                                                                                ),
                                                                                maxLines: 1,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Inter',
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Image
                                                                            .network(
                                                                          photoSharingPostPostsRecord
                                                                              .postPhoto,
                                                                          width:
                                                                              250.0,
                                                                          height:
                                                                              250.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              16.0,
                                                                              9.0,
                                                                              16.0,
                                                                              12.0),
                                                                          child:
                                                                              custom_widgets.PhotoCaption(
                                                                            width:
                                                                                218.0,
                                                                            height:
                                                                                17.0,
                                                                            name:
                                                                                columnUsersRecord.username,
                                                                            caption:
                                                                                photoSharingPostPostsRecord.postCaption,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (messageChatMessagesRecord.user !=
                                          currentUserReference)
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.75,
                                                decoration: const BoxDecoration(),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if ((messageChatMessagesRecord
                                                                  .postRef ==
                                                              null) &&
                                                          (messageChatMessagesRecord
                                                                  .commentRef ==
                                                              null))
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF6F6F6),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              4.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              32.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              4.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              32.0),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16.0,
                                                                            10.0,
                                                                            16.0,
                                                                            10.0),
                                                                    child: Text(
                                                                      messageChatMessagesRecord
                                                                          .text,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            fontSize:
                                                                                15.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            lineHeight:
                                                                                1.5,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      if ((messageChatMessagesRecord
                                                                  .postRef !=
                                                              null) &&
                                                          (messageChatMessagesRecord
                                                                  .commentRef !=
                                                              null))
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            context.pushNamed(
                                                              'PostDetails',
                                                              queryParameters: {
                                                                'post':
                                                                    serializeParam(
                                                                  messageChatMessagesRecord
                                                                      .postRef,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                          child: Stack(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    -1.0, 1.0),
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            20.0),
                                                                child: StreamBuilder<
                                                                    PostsRecord>(
                                                                  stream: PostsRecord
                                                                      .getDocument(
                                                                          messageChatMessagesRecord
                                                                              .postRef!),
                                                                  builder: (context,
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
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final postPhotoPostsRecord =
                                                                        snapshot
                                                                            .data!;
                                                                    return ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                      child: Image
                                                                          .network(
                                                                        postPhotoPostsRecord
                                                                            .postPhoto,
                                                                        width:
                                                                            200.0,
                                                                        height:
                                                                            200.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            24.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: StreamBuilder<
                                                                    CommentsRecord>(
                                                                  stream: CommentsRecord
                                                                      .getDocument(
                                                                          messageChatMessagesRecord
                                                                              .commentRef!),
                                                                  builder: (context,
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
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final postCommentCommentsRecord =
                                                                        snapshot
                                                                            .data!;
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFF5F5F5),
                                                                            borderRadius:
                                                                                BorderRadius.circular(16.0),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: FutureBuilder<UsersRecord>(
                                                                                    future: UsersRecord.getDocumentOnce(postCommentCommentsRecord.postUser!),
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
                                                                                      final rowUsersRecord = snapshot.data!;
                                                                                      return Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Align(
                                                                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                              child: Container(
                                                                                                width: 37.0,
                                                                                                height: 37.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                  image: DecorationImage(
                                                                                                    fit: BoxFit.cover,
                                                                                                    image: Image.network(
                                                                                                      valueOrDefault<String>(
                                                                                                        rowUsersRecord.photoUrl,
                                                                                                        'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                                                      ),
                                                                                                    ).image,
                                                                                                  ),
                                                                                                  shape: BoxShape.circle,
                                                                                                  border: Border.all(
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    width: 2.0,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 9.0, 0.0, 0.0),
                                                                                                  child: custom_widgets.PhotoCaption(
                                                                                                    width: double.infinity,
                                                                                                    height: 17.0,
                                                                                                    name: valueOrDefault<String>(
                                                                                                      rowUsersRecord.username,
                                                                                                      'user',
                                                                                                    ),
                                                                                                    caption: postCommentCommentsRecord.comment,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
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
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      if ((messageChatMessagesRecord
                                                                  .postRef !=
                                                              null) &&
                                                          (messageChatMessagesRecord
                                                                  .commentRef ==
                                                              null))
                                                        StreamBuilder<
                                                            PostsRecord>(
                                                          stream: PostsRecord
                                                              .getDocument(
                                                                  messageChatMessagesRecord
                                                                      .postRef!),
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
                                                            final photoSharingPostPostsRecord =
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
                                                                      messageChatMessagesRecord
                                                                          .postRef,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFFF5F5F5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16.0),
                                                                ),
                                                                child: FutureBuilder<
                                                                    UsersRecord>(
                                                                  future: UsersRecord
                                                                      .getDocumentOnce(
                                                                          photoSharingPostPostsRecord
                                                                              .postUser!),
                                                                  builder: (context,
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
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final columnUsersRecord =
                                                                        snapshot
                                                                            .data!;
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              16.0,
                                                                              8.0,
                                                                              16.0,
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                  child: Container(
                                                                                    width: 37.0,
                                                                                    height: 37.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      image: DecorationImage(
                                                                                        fit: BoxFit.cover,
                                                                                        image: Image.network(
                                                                                          valueOrDefault<String>(
                                                                                            columnUsersRecord.photoUrl,
                                                                                            'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                                                          ),
                                                                                        ).image,
                                                                                      ),
                                                                                      shape: BoxShape.circle,
                                                                                      border: Border.all(
                                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                                        width: 2.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                columnUsersRecord.username.maybeHandleOverflow(
                                                                                  maxChars: 26,
                                                                                  replacement: '…',
                                                                                ),
                                                                                maxLines: 1,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Inter',
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Image
                                                                            .network(
                                                                          photoSharingPostPostsRecord
                                                                              .postPhoto,
                                                                          width:
                                                                              250.0,
                                                                          height:
                                                                              250.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              16.0,
                                                                              9.0,
                                                                              16.0,
                                                                              12.0),
                                                                          child:
                                                                              custom_widgets.PhotoCaption(
                                                                            width:
                                                                                218.0,
                                                                            height:
                                                                                17.0,
                                                                            name:
                                                                                columnUsersRecord.username,
                                                                            caption:
                                                                                photoSharingPostPostsRecord.postCaption,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            15.0, 0.0, 15.0, 24.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10.0,
                              sigmaY: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xCDF3F3F3),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: AuthUserStreamWidget(
                                        builder: (context) => Container(
                                          width: 45.0,
                                          height: 45.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(
                                            valueOrDefault<String>(
                                              currentUserPhoto,
                                              'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: Stack(
                                          alignment:
                                              const AlignmentDirectional(1.0, 1.0),
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _model.messageTextController,
                                              focusNode:
                                                  _model.messageFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                hintText: 'Message...',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00DADADA),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0.0, 8.0,
                                                            55.0, 8.0),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 15.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        lineHeight: 1.5,
                                                      ),
                                              maxLines: 5,
                                              minLines: 1,
                                              validator: _model
                                                  .messageTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 16.0, 15.0),
                                              child: StreamBuilder<ChatsRecord>(
                                                stream: ChatsRecord.getDocument(
                                                    widget.chat!),
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
                                                  final sendChatsRecord =
                                                      snapshot.data!;
                                                  return InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      var chatMessagesRecordReference =
                                                          ChatMessagesRecord
                                                              .collection
                                                              .doc();
                                                      await chatMessagesRecordReference
                                                          .set(
                                                              createChatMessagesRecordData(
                                                        user:
                                                            currentUserReference,
                                                        chat: widget.chat,
                                                        text: _model
                                                            .messageTextController
                                                            .text,
                                                        timestamp:
                                                            getCurrentTimestamp,
                                                      ));
                                                      _model.message = ChatMessagesRecord
                                                          .getDocumentFromData(
                                                              createChatMessagesRecordData(
                                                                user:
                                                                    currentUserReference,
                                                                chat:
                                                                    widget.chat,
                                                                text: _model
                                                                    .messageTextController
                                                                    .text,
                                                                timestamp:
                                                                    getCurrentTimestamp,
                                                              ),
                                                              chatMessagesRecordReference);

                                                      await widget.chat!
                                                          .update({
                                                        ...createChatsRecordData(
                                                          lastMessage: _model
                                                              .messageTextController
                                                              .text,
                                                          lastMessageTime:
                                                              getCurrentTimestamp,
                                                          lastMessageSentBy:
                                                              currentUserReference,
                                                        ),
                                                        ...mapToFirestore(
                                                          {
                                                            'last_message_seen_by':
                                                                FieldValue
                                                                    .arrayRemove([
                                                              sendChatsRecord
                                                                          .userA ==
                                                                      currentUserReference
                                                                  ? sendChatsRecord
                                                                      .userB
                                                                  : sendChatsRecord
                                                                      .userA
                                                            ]),
                                                          },
                                                        ),
                                                      });
                                                      setState(() {
                                                        _model
                                                            .messageTextController
                                                            ?.clear();
                                                      });

                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      'Send',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary,
                                                            fontSize: 15.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
