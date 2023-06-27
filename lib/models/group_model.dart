class Group {
  final String? id;
  final String groupName;
  final String description;
  final int quantity;
  final DateTime endDate;
  final DateTime startDate;
  final String? menuId;

  Group({
    this.id,
    required this.groupName,
    required this.description,
    required this.quantity,
    required this.endDate,
    required this.startDate,
    this.menuId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      groupName: json['groupName'],
      description: json['description'],
      quantity: json['quantity'],
      endDate: DateTime.parse(json['endDate']),
      startDate: DateTime.parse(json['startDate']),
      menuId: json['menuId'],
    );
  }

  // Serialize Group object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupName': groupName,
      'description': description,
      'quantity': quantity,
      'endDate': endDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'menuId': menuId,
    };
  }
}
