// Message models for session chat

class MessageTime {
  final int? created;
  final int? completed;
  final int? start;
  final int? end;

  MessageTime({this.created, this.completed, this.start, this.end});

  factory MessageTime.fromJson(Map<String, dynamic> json) => MessageTime(
    created: json['created'],
    completed: json['completed'],
    start: json['start'],
    end: json['end'],
  );
}

class MessageTokens {
  final int total;
  final int input;
  final int output;
  final int reasoning;

  MessageTokens({
    this.total = 0,
    this.input = 0,
    this.output = 0,
    this.reasoning = 0,
  });

  factory MessageTokens.fromJson(Map<String, dynamic> json) => MessageTokens(
    total: json['total'] ?? 0,
    input: json['input'] ?? 0,
    output: json['output'] ?? 0,
    reasoning: json['reasoning'] ?? 0,
  );
}

class MessagePath {
  final String cwd;
  final String root;

  MessagePath({required this.cwd, required this.root});

  factory MessagePath.fromJson(Map<String, dynamic> json) => MessagePath(
    cwd: json['cwd'] ?? '',
    root: json['root'] ?? '',
  );
}

class MessageInfo {
  final String role;
  final MessageTime time;
  final String? parentID;
  final String? modelID;
  final String? providerID;
  final String? mode;
  final String? agent;
  final MessagePath? path;
  final MessageTokens? tokens;
  final String? finish;
  final String id;
  final String sessionID;

  MessageInfo({
    required this.role,
    required this.time,
    this.parentID,
    this.modelID,
    this.providerID,
    this.mode,
    this.agent,
    this.path,
    this.tokens,
    this.finish,
    required this.id,
    required this.sessionID,
  });

  factory MessageInfo.fromJson(Map<String, dynamic> json) => MessageInfo(
    role: json['role'] ?? 'user',
    time: MessageTime.fromJson(json['time'] ?? {}),
    parentID: json['parentID'],
    modelID: json['modelID'],
    providerID: json['providerID'],
    mode: json['mode'],
    agent: json['agent'],
    path: json['path'] != null ? MessagePath.fromJson(json['path']) : null,
    tokens: json['tokens'] != null ? MessageTokens.fromJson(json['tokens']) : null,
    finish: json['finish'],
    id: json['id'] ?? '',
    sessionID: json['sessionID'] ?? '',
  );
}

class ToolState {
  final String status;
  final Map<String, dynamic>? input;
  final Map<String, dynamic>? output;

  ToolState({required this.status, this.input, this.output});

  factory ToolState.fromJson(Map<String, dynamic> json) => ToolState(
    status: json['status'] ?? '',
    input: json['input'],
    output: json['output'],
  );
}

class MessagePart {
  final String type;
  final String? text;
  final String? tool;
  final String? callID;
  final ToolState? state;
  final String? reason;
  final String id;
  final String? messageID;
  final String? sessionID;
  final MessageTime? time;

  MessagePart({
    required this.type,
    this.text,
    this.tool,
    this.callID,
    this.state,
    this.reason,
    required this.id,
    this.messageID,
    this.sessionID,
    this.time,
  });

  factory MessagePart.fromJson(Map<String, dynamic> json) => MessagePart(
    type: json['type'] ?? '',
    text: json['text'],
    tool: json['tool'],
    callID: json['callID'],
    state: json['state'] != null ? ToolState.fromJson(json['state']) : null,
    reason: json['reason'],
    id: json['id'] ?? '',
    messageID: json['messageID'],
    sessionID: json['sessionID'],
    time: json['time'] != null ? MessageTime.fromJson(json['time']) : null,
  );
}

class Message {
  final MessageInfo info;
  final List<MessagePart> parts;

  Message({required this.info, required this.parts});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    info: MessageInfo.fromJson(json['info'] ?? {}),
    parts: (json['parts'] as List<dynamic>?)
        ?.map((e) => MessagePart.fromJson(e))
        .toList() ?? [],
  );
}
